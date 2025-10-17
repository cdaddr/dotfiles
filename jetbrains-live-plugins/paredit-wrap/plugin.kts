import com.intellij.openapi.actionSystem.*
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.command.WriteCommandAction
import com.intellij.openapi.editor.Editor
import com.intellij.openapi.editor.EditorModificationUtil
import com.intellij.openapi.fileEditor.FileEditorManager
import com.intellij.openapi.project.Project
import com.intellij.notification.Notification
import com.intellij.notification.NotificationType
import com.intellij.openapi.util.TextRange

class WrapService(private val project: Project) {

    private fun getCurrentEditor(): Editor? {
        return FileEditorManager.getInstance(project).selectedTextEditor
    }

    private fun isIdentifierChar(c: Char): Boolean {
        return c.isLetterOrDigit() || c == '_'
    }

    private fun isOpenBracket(c: Char): Boolean {
        return c in "{([<\"'`"
    }

    private fun isCloseBracket(c: Char): Boolean {
        return c in "})]>\"'`"
    }

    private fun matchingBracket(c: Char): Char {
        return when (c) {
            '{', '}' -> '}'
            '(', ')' -> ')'
            '[', ']' -> ']'
            '<', '>' -> '>'
            '"' -> '"'
            '\'' -> '\''
            '`' -> '`'
            else -> c
        }
    }

    private fun findMatchingBracket(text: String, startOffset: Int, openChar: Char): Int? {
        val closeChar = matchingBracket(openChar)
        var depth = 1
        var i = startOffset + 1

        while (i < text.length && depth > 0) {
            if (openChar == closeChar) {
                if (text[i] == openChar) depth--
            } else {
                when (text[i]) {
                    openChar -> depth++
                    closeChar -> depth--
                }
            }
            if (depth == 0) return i
            i++
        }
        return null
    }

    private fun findMatchingOpenBracket(text: String, startOffset: Int, closeChar: Char): Int? {
        val openChar = when (closeChar) {
            '}' -> '{'
            ')' -> '('
            ']' -> '['
            '>' -> '<'
            else -> closeChar
        }
        var depth = 1
        var i = startOffset - 1

        while (i >= 0 && depth > 0) {
            if (openChar == closeChar) {
                if (text[i] == openChar) depth--
            } else {
                when (text[i]) {
                    closeChar -> depth++
                    openChar -> depth--
                }
            }
            if (depth == 0) return i
            i--
        }
        return null
    }

    private fun getThingToWrap(editor: Editor): TextRange? {
        val document = editor.document
        val text = document.text
        val offset = editor.caretModel.offset

        if (offset >= text.length) return null

        val charAtCursor = text[offset]

        // If on a space, skip to next non-space
        if (charAtCursor.isWhitespace()) {
            var nextOffset = offset
            while (nextOffset < text.length && text[nextOffset].isWhitespace()) {
                nextOffset++
            }
            if (nextOffset >= text.length) return null
            return getThingToWrapAt(editor, nextOffset)
        }

        return getThingToWrapAt(editor, offset)
    }

    private fun getThingToWrapAt(editor: Editor, offset: Int): TextRange? {
        val document = editor.document
        val text = document.text

        if (offset >= text.length) return null

        val charAtOffset = text[offset]

        // Handle open brackets - find matching close
        if (isOpenBracket(charAtOffset)) {
            val closeOffset = findMatchingBracket(text, offset, charAtOffset)
            if (closeOffset != null) {
                return TextRange(offset, closeOffset + 1)
            }
        }

        // Handle close brackets - find matching open
        if (isCloseBracket(charAtOffset)) {
            val openOffset = findMatchingOpenBracket(text, offset, charAtOffset)
            if (openOffset != null) {
                return TextRange(openOffset, offset + 1)
            }
        }

        // Handle identifier/word
        if (isIdentifierChar(charAtOffset)) {
            var start = offset
            var end = offset

            while (start > 0 && isIdentifierChar(text[start - 1])) {
                start--
            }

            while (end < text.length && isIdentifierChar(text[end])) {
                end++
            }

            return TextRange(start, end)
        }

        return null
    }

    fun wrapWithBraces(openChar: String, closeChar: String, isTag: Boolean = false) {
        val editor = getCurrentEditor() ?: return

        val range = getThingToWrap(editor) ?: return

        WriteCommandAction.runWriteCommandAction(project) {
            val document = editor.document
            val textToWrap = document.getText(range)

            val wrapped = if (isTag) {
                "<$openChar>$textToWrap</$openChar>"
            } else {
                "$openChar$textToWrap$closeChar"
            }

            document.replaceString(range.startOffset, range.endOffset, wrapped)

            // Move cursor to after the opening wrapper
            editor.caretModel.moveToOffset(range.startOffset + openChar.length)
        }
    }

    fun wrapWith(openChar: String, closeChar: String) {
        wrapWithBraces(openChar, closeChar, false)
    }

    fun wrapWithTag(tagName: String) {
        wrapWithBraces(tagName, tagName, true)
    }
}

// Actions for each wrapper type
class WrapCurlyBracesAction : AnAction("Wrap with {}") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).wrapWith("{", "}") }
    }
}

class WrapSquareBracketsAction : AnAction("Wrap with []") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).wrapWith("[", "]") }
    }
}

class WrapParenthesesAction : AnAction("Wrap with ()") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).wrapWith("(", ")") }
    }
}

class WrapAngleBracketsAction : AnAction("Wrap with <>") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).wrapWith("<", ">") }
    }
}

class WrapDoubleQuotesAction : AnAction("Wrap with \"\"") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).wrapWith("\"", "\"") }
    }
}

class WrapSingleQuotesAction : AnAction("Wrap with ''") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).wrapWith("'", "'") }
    }
}

class WrapBackticksAction : AnAction("Wrap with ``") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).wrapWith("`", "`") }
    }
}

class WrapTagAction : AnAction("Wrap with <tag></tag>") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).wrapWithTag("tag") }
    }
}

// Register actions
val actionManager = ActionManager.getInstance()

val actionIds = listOf(
    "PareditWrapCurly",
    "PareditWrapSquare",
    "PareditWrapParen",
    "PareditWrapAngle",
    "PareditWrapDoubleQuote",
    "PareditWrapSingleQuote",
    "PareditWrapBacktick",
    "PareditWrapTag"
)

actionManager.registerAction("PareditWrapCurly", WrapCurlyBracesAction())
actionManager.registerAction("PareditWrapSquare", WrapSquareBracketsAction())
actionManager.registerAction("PareditWrapParen", WrapParenthesesAction())
actionManager.registerAction("PareditWrapAngle", WrapAngleBracketsAction())
actionManager.registerAction("PareditWrapDoubleQuote", WrapDoubleQuotesAction())
actionManager.registerAction("PareditWrapSingleQuote", WrapSingleQuotesAction())
actionManager.registerAction("PareditWrapBacktick", WrapBackticksAction())
actionManager.registerAction("PareditWrapTag", WrapTagAction())

// Cleanup on plugin disable
if (isIdeStartup) {
    com.intellij.openapi.util.Disposer.register(pluginDisposable) {
        actionIds.forEach { actionId ->
            try {
                actionManager.unregisterAction(actionId)
            } catch (e: Exception) {
                // Ignore cleanup errors
            }
        }
    }
}

val notification = Notification(
    "Paredit Wrap",
    "Paredit Wrap",
    "Paredit-like wrapping plugin loaded! Map keybindings to actions: ${actionIds.joinToString(", ")}",
    NotificationType.INFORMATION
)
notification.notify(null)
