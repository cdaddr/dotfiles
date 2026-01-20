import com.intellij.openapi.actionSystem.*
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.editor.Editor
import com.intellij.openapi.editor.LogicalPosition
import com.intellij.openapi.fileEditor.*
import com.intellij.openapi.project.Project
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.openapi.wm.IdeFocusManager
import com.intellij.notification.Notification
import com.intellij.notification.NotificationType
import com.intellij.openapi.keymap.KeymapManager
import com.intellij.openapi.util.Disposer
import java.io.File

data class HarpoonEntry(
    val filePath: String
)

class HarpoonService(private val project: Project) {
    private val jumpList = mutableListOf<HarpoonEntry>()
    private var currentIndex = -1
    private var lastVisitedFromJumpList: String? = null
    private val storageFile = File(project.basePath, ".idea/HarpoonLivePlugin.txt")

    init {
        loadJumpList()
    }

    private fun loadJumpList() {
        if (storageFile.exists()) {
            try {
                jumpList.clear()
                storageFile.readLines().forEach { line ->
                    if (line.isNotBlank()) {
                        jumpList.add(HarpoonEntry(line.trim()))
                    }
                }
            } catch (e: Exception) {
                // Ignore loading errors
            }
        }
    }

    private fun saveJumpList() {
        try {
            storageFile.parentFile?.mkdirs()
            storageFile.writeText(
                jumpList.joinToString("\n") { it.filePath }
            )
        } catch (e: Exception) {
            // Ignore save errors
        }
    }

    fun clearJumpList() {
        try {
            jumpList.removeAll{true}
            saveJumpList()
            show("Harpoon jump list cleared")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun markFile() {
        val file = getCurrentFile() ?: return

        val entry = HarpoonEntry(file.path)
        val existingIndex = jumpList.indexOfFirst { it.filePath == file.path }

        if (existingIndex >= 0) {
            jumpList[existingIndex] = entry
        } else {
            jumpList.add(entry)
        }

        saveJumpList()
        show("File marked in Harpoon")
    }

    fun removeFile() {
        val file = getCurrentFile() ?: return
        val removed = jumpList.removeAll { it.filePath == file.path }

        if (removed) {
            saveJumpList()
            show("File removed from Harpoon")
        } else {
            show("File not in Harpoon list")
        }
    }

    fun nextFile() {
        if (jumpList.isEmpty()) {
            show("Harpoon list is empty")
            return
        }

        val currentFile = getCurrentFile()
        if (currentFile != null && isFileInJumpList(currentFile.path)) {
            currentIndex = jumpList.indexOfFirst { it.filePath == currentFile.path }
        }

        currentIndex = (currentIndex + 1) % jumpList.size
        navigateToFile(jumpList[currentIndex])
    }

    fun previousFile() {
        if (jumpList.isEmpty()) {
            show("Harpoon list is empty")
            return
        }

        val currentFile = getCurrentFile()
        if (currentFile != null && isFileInJumpList(currentFile.path)) {
            currentIndex = jumpList.indexOfFirst { it.filePath == currentFile.path }
        }

        currentIndex = if (currentIndex <= 0) jumpList.size - 1 else currentIndex - 1
        navigateToFile(jumpList[currentIndex])
    }

    private fun isFileInJumpList(filePath: String): Boolean {
        return jumpList.any { it.filePath == filePath }
    }

    private fun navigateToFile(entry: HarpoonEntry) {
        val file = File(entry.filePath)
        if (!file.exists()) {
            show("File no longer exists: ${entry.filePath}")
            return
        }

        val virtualFile = com.intellij.openapi.vfs.LocalFileSystem.getInstance().findFileByPath(entry.filePath)
        if (virtualFile == null) {
            show("Cannot find file: ${entry.filePath}")
            return
        }

        lastVisitedFromJumpList = entry.filePath

        ApplicationManager.getApplication().invokeLater {
            val descriptor = OpenFileDescriptor(project, virtualFile)
            descriptor.navigate(true)
        }
    }


    private fun getCurrentEditor(): Editor? {
        return FileEditorManager.getInstance(project).selectedTextEditor
    }

    private fun getCurrentFile(): VirtualFile? {
        return FileEditorManager.getInstance(project).selectedFiles.firstOrNull()
    }

    fun openJumpListFile() {
        try {
            val virtualFile = com.intellij.openapi.vfs.LocalFileSystem.getInstance().findFileByPath(storageFile.path)
            if (virtualFile != null) {
                ApplicationManager.getApplication().invokeLater {
                    val descriptor = OpenFileDescriptor(project, virtualFile)
                    descriptor.navigate(true)
                    
                    // Set up file modification listener to sync state when file is saved
                    val connection = project.messageBus.connect()
                    val listener = object : FileEditorManagerListener {
                        override fun fileClosed(source: FileEditorManager, file: VirtualFile) {
                            if (file.path == storageFile.path) {
                                // Reload jump list when the file is closed (after manual editing)
                                loadJumpList()
                                show("Harpoon list resynced from file")
                                // Remove this listener after use
                                connection.disconnect()
                            }
                        }
                    }
                    connection.subscribe(FileEditorManagerListener.FILE_EDITOR_MANAGER, listener)
                }
            } else {
                // Create the file if it doesn't exist
                saveJumpList()
                openJumpListFile() // Retry after creating
            }
        } catch (e: Exception) {
            show("Error opening jump list file: ${e.message}")
        }
    }

    private fun show(message: String) {
        Notification(
            "Harpoon",
            "Harpoon",
            message,
            NotificationType.INFORMATION
        ).notify(project)
    }
}

// Create actions for key bindings
class HarpoonMarkAction : AnAction("Harpoon Mark File") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { HarpoonService(it).markFile() }
    }
}

class HarpoonRemoveAction : AnAction("Harpoon Remove File") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { HarpoonService(it).removeFile() }
    }
}

class HarpoonNextAction : AnAction("Harpoon Next File") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { HarpoonService(it).nextFile() }
    }
}

class HarpoonPreviousAction : AnAction("Harpoon Previous File") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { HarpoonService(it).previousFile() }
    }
}

class HarpoonClearAction : AnAction("Harpoon Clear List") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { HarpoonService(it).clearJumpList() }
    }
}

class HarpoonListAction : AnAction("Harpoon List") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { HarpoonService(it).openJumpListFile() }
    }
}

// Register actions and key bindings
val actionManager = ActionManager.getInstance()
val keymap = KeymapManager.getInstance().activeKeymap

// List of action IDs for cleanup
val actionIds = listOf("HarpoonMark", "HarpoonRemove", "HarpoonNext", "HarpoonPrevious", "HarpoonClear", "HarpoonList")

// Register actions
actionManager.registerAction("HarpoonMark", HarpoonMarkAction())
actionManager.registerAction("HarpoonRemove", HarpoonRemoveAction())
actionManager.registerAction("HarpoonNext", HarpoonNextAction())
actionManager.registerAction("HarpoonPrevious", HarpoonPreviousAction())
actionManager.registerAction("HarpoonClear", HarpoonClearAction())
actionManager.registerAction("HarpoonList", HarpoonListAction())

//// Add default key bindings (users can change these in IDE settings)
//keymap.addShortcut("HarpoonMark", KeyboardShortcut.fromString("ctrl alt M"))
//keymap.addShortcut("HarpoonRemove", KeyboardShortcut.fromString("ctrl alt R"))
//keymap.addShortcut("HarpoonNext", KeyboardShortcut.fromString("ctrl alt N"))
//keymap.addShortcut("HarpoonPrevious", KeyboardShortcut.fromString("ctrl alt P"))
//keymap.addShortcut("HarpoonClear", KeyboardShortcut.fromString("ctrl alt C"))

// Register disposal callback to clean up when plugin is disabled
if (isIdeStartup) {
    com.intellij.openapi.util.Disposer.register(pluginDisposable) {
        // Unregister all actions when plugin is disabled
        actionIds.forEach { actionId ->
            try {
                actionManager.unregisterAction(actionId)
            } catch (e: Exception) {
                // Ignore cleanup errors
            }
        }
    }
}

// Show loading message
// val notification = Notification("Harpoon", "Harpoon", "Harpoon Live Plugin loaded!", NotificationType.INFORMATION)
// notification.notify(null)