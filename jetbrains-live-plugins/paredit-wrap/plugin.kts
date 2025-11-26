import com.intellij.openapi.actionSystem.*
import com.intellij.openapi.command.WriteCommandAction
import com.intellij.openapi.editor.Editor
import com.intellij.openapi.fileEditor.FileEditorManager
import com.intellij.openapi.project.Project
import com.intellij.notification.Notification
import com.intellij.notification.NotificationType
import com.intellij.openapi.util.TextRange
import com.intellij.psi.*

class WrapService(private val project: Project) {

    private fun getCurrentEditor(): Editor? {
        return FileEditorManager.getInstance(project).selectedTextEditor
    }

    private fun getPsiFile(editor: Editor): PsiFile? {
        val virtualFile = FileEditorManager.getInstance(project).selectedFiles.firstOrNull() ?: return null
        return PsiManager.getInstance(project).findFile(virtualFile)
    }

    private fun isIdentifierChar(c: Char): Boolean {
        return c.isLetterOrDigit() || c == '_'
    }

    private fun getThingToWrap(editor: Editor): TextRange? {
        val offset = editor.caretModel.offset
        val document = editor.document
        val text = document.text

        if (offset >= text.length) return null

        val charAtCursor = text[offset]

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
        val psiFile = getPsiFile(editor) ?: return fallbackGetThingToWrap(editor, offset)

        PsiDocumentManager.getInstance(project).commitDocument(editor.document)

        val element = psiFile.findElementAt(offset) ?: return fallbackGetThingToWrap(editor, offset)

        val range = when {
            isStringLiteral(element) -> getStringLiteralRange(element)
            isBracketElement(element, offset) -> getBracketRange(element, offset)
            isIdentifierElement(element) -> getIdentifierRange(element)
            else -> null
        }

        return range ?: fallbackGetThingToWrap(editor, offset)
    }

    private fun isStringLiteral(element: PsiElement): Boolean {
        val type = element.node?.elementType?.toString() ?: ""
        val parentType = element.parent?.node?.elementType?.toString() ?: ""
        val firstChar = element.text.firstOrNull()
        return type.contains("STRING") ||
               parentType.contains("STRING") ||
               parentType.contains("LITERAL") && firstChar != null && firstChar in "\"'`"
    }

    private fun getStringLiteralRange(element: PsiElement): TextRange? {
        var current: PsiElement? = element

        while (current != null) {
            val type = current!!.node?.elementType?.toString() ?: ""
            val text = current!!.text
            val firstChar = text.firstOrNull()
            val lastChar = text.lastOrNull()

            if ((type.contains("STRING_LITERAL") || type.contains("STRING_TEMPLATE") || type.contains("LITERAL_EXPRESSION")) &&
                firstChar != null && firstChar in "\"'`" && lastChar != null && lastChar in "\"'`") {
                return current!!.textRange
            }

            if (current!! is PsiFile) break
            current = current!!.parent
        }
        return null
    }

    private fun isBracketElement(element: PsiElement, offset: Int): Boolean {
        val text = element.text
        if (text.isEmpty()) return false

        val localOffset = offset - element.textRange.startOffset
        if (localOffset < 0 || localOffset >= text.length) return false

        val charAtOffset = text[localOffset]
        return charAtOffset in "(){}[]<>"
    }

    private fun getBracketRange(element: PsiElement, offset: Int): TextRange? {
        var current: PsiElement? = element

        while (current != null) {
            val text = current!!.text
            val type = current!!.node?.elementType?.toString() ?: ""

            if ((text.startsWith("(") && text.endsWith(")")) ||
                (text.startsWith("{") && text.endsWith("}")) ||
                (text.startsWith("[") && text.endsWith("]")) ||
                (text.startsWith("<") && text.endsWith(">"))) {

                if (current!!.textRange.contains(offset)) {
                    return current!!.textRange
                }
            }

            if (type.contains("PARENTHESIZED") ||
                type.contains("ARRAY") ||
                type.contains("OBJECT") ||
                type.contains("BLOCK")) {
                return current!!.textRange
            }

            if (current!! is PsiFile) break
            current = current!!.parent
        }

        return null
    }

    private fun isIdentifierElement(element: PsiElement): Boolean {
        val type = element.node?.elementType?.toString() ?: ""
        return type.contains("IDENTIFIER") || type.contains("REFERENCE")
    }

    private fun getIdentifierRange(element: PsiElement): TextRange? {
        var current: PsiElement? = element

        while (current != null) {
            val type = current!!.node?.elementType?.toString() ?: ""

            if (type.contains("IDENTIFIER") || type.contains("REFERENCE_EXPRESSION")) {
                return current!!.textRange
            }

            if (current!! is PsiFile) break
            current = current!!.parent
        }

        return element.textRange
    }

    private fun fallbackGetThingToWrap(editor: Editor, offset: Int): TextRange? {
        val document = editor.document
        val text = document.text

        if (offset >= text.length) return null

        val charAtOffset = text[offset]

        if (charAtOffset in "(){}[]<>\"'`") {
            val matching = when (charAtOffset) {
                '(' -> ')'
                ')' -> '('
                '{' -> '}'
                '}' -> '{'
                '[' -> ']'
                ']' -> '['
                '<' -> '>'
                '>' -> '<'
                else -> charAtOffset
            }

            if (charAtOffset in "({[<\"'`") {
                val end = findMatchingForward(text, offset, charAtOffset, matching)
                if (end != null) return TextRange(offset, end + 1)
            } else {
                val start = findMatchingBackward(text, offset, charAtOffset, matching)
                if (start != null) return TextRange(start, offset + 1)
            }
        }

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

    private fun findMatchingForward(text: String, start: Int, openChar: Char, closeChar: Char): Int? {
        var depth = 1
        var i = start + 1

        while (i < text.length && depth > 0) {
            if (text[i] == '\\' && openChar in "\"'`") {
                i += 2
                continue
            }

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

    private fun findMatchingBackward(text: String, start: Int, closeChar: Char, openChar: Char): Int? {
        var depth = 1
        var i = start - 1

        while (i >= 0 && depth > 0) {
            if (i > 0 && text[i - 1] == '\\' && closeChar in "\"'`") {
                i -= 2
                continue
            }

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

            editor.caretModel.moveToOffset(range.startOffset + openChar.length)
        }
    }

    fun wrapWith(openChar: String, closeChar: String) {
        wrapWithBraces(openChar, closeChar, false)
    }

    fun wrapWithTag(tagName: String) {
        wrapWithBraces(tagName, tagName, true)
    }

    private data class BracketPair(val openOffset: Int, val closeOffset: Int, val openChar: Char, val closeChar: Char)

    private fun findContainingBrackets(text: String, cursorOffset: Int): BracketPair? {
        var depth = 0
        var openOffset = -1
        var openChar = ' '

        for (i in cursorOffset - 1 downTo 0) {
            val c = text[i]
            when (c) {
                ')' -> depth++
                '}' -> depth++
                ']' -> depth++
                '(' -> {
                    if (depth == 0) {
                        openOffset = i
                        openChar = c
                        break
                    }
                    depth--
                }
                '{' -> {
                    if (depth == 0) {
                        openOffset = i
                        openChar = c
                        break
                    }
                    depth--
                }
                '[' -> {
                    if (depth == 0) {
                        openOffset = i
                        openChar = c
                        break
                    }
                    depth--
                }
            }
        }

        if (openOffset == -1) return null

        val closeChar = when (openChar) {
            '(' -> ')'
            '{' -> '}'
            '[' -> ']'
            else -> return null
        }

        depth = 0
        for (i in openOffset + 1 until text.length) {
            val c = text[i]
            when (c) {
                openChar -> depth++
                closeChar -> {
                    if (depth == 0) {
                        return BracketPair(openOffset, i, openChar, closeChar)
                    }
                    depth--
                }
            }
        }

        return null
    }

    private fun findNextThing(text: String, startOffset: Int): TextRange? {
        var i = startOffset
        while (i < text.length && text[i].isWhitespace()) {
            i++
        }
        if (i >= text.length) return null

        return fallbackGetThingToWrap(getCurrentEditor()!!, i)
    }

    private fun findPreviousThing(text: String, endOffset: Int): TextRange? {
        var i = endOffset - 1
        while (i >= 0 && text[i].isWhitespace()) {
            i--
        }
        if (i < 0) return null

        return fallbackGetThingToWrap(getCurrentEditor()!!, i)
    }

    fun slurpForward() {
        val editor = getCurrentEditor() ?: return
        val document = editor.document
        val text = document.text
        val cursorOffset = editor.caretModel.offset

        val brackets = findContainingBrackets(text, cursorOffset) ?: return

        val nextThing = findNextThing(text, brackets.closeOffset + 1) ?: return

        WriteCommandAction.runWriteCommandAction(project) {
            document.deleteString(brackets.closeOffset, brackets.closeOffset + 1)
            document.insertString(nextThing.endOffset, brackets.closeChar.toString())
        }
    }

    fun slurpBackward() {
        val editor = getCurrentEditor() ?: return
        val document = editor.document
        val text = document.text
        val cursorOffset = editor.caretModel.offset

        val brackets = findContainingBrackets(text, cursorOffset) ?: return

        val prevThing = findPreviousThing(text, brackets.openOffset) ?: return

        WriteCommandAction.runWriteCommandAction(project) {
            document.deleteString(brackets.openOffset, brackets.openOffset + 1)
            document.insertString(prevThing.startOffset, brackets.openChar.toString())
        }
    }
}

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

class SlurpForwardAction : AnAction("Slurp Forward") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).slurpForward() }
    }
}

class SlurpBackwardAction : AnAction("Slurp Backward") {
    override fun actionPerformed(e: AnActionEvent) {
        e.project?.let { WrapService(it).slurpBackward() }
    }
}

val actionManager = ActionManager.getInstance()

val actionIds = listOf(
    "PareditWrapCurly",
    "PareditWrapSquare",
    "PareditWrapParen",
    "PareditWrapAngle",
    "PareditWrapDoubleQuote",
    "PareditWrapSingleQuote",
    "PareditWrapBacktick",
    "PareditWrapTag",
    "PareditSlurpForward",
    "PareditSlurpBackward"
)

actionManager.registerAction("PareditWrapCurly", WrapCurlyBracesAction())
actionManager.registerAction("PareditWrapSquare", WrapSquareBracketsAction())
actionManager.registerAction("PareditWrapParen", WrapParenthesesAction())
actionManager.registerAction("PareditWrapAngle", WrapAngleBracketsAction())
actionManager.registerAction("PareditWrapDoubleQuote", WrapDoubleQuotesAction())
actionManager.registerAction("PareditWrapSingleQuote", WrapSingleQuotesAction())
actionManager.registerAction("PareditWrapBacktick", WrapBackticksAction())
actionManager.registerAction("PareditWrapTag", WrapTagAction())
actionManager.registerAction("PareditSlurpForward", SlurpForwardAction())
actionManager.registerAction("PareditSlurpBackward", SlurpBackwardAction())

if (isIdeStartup) {
    com.intellij.openapi.util.Disposer.register(pluginDisposable) {
        actionIds.forEach { actionId ->
            try {
                actionManager.unregisterAction(actionId)
            } catch (e: Exception) {
            }
        }
    }
}

val notification = Notification(
    "Paredit Wrap",
    "Paredit Wrap",
    "Paredit-like plugin loaded! Actions: wrap, slurp forward/backward",
    NotificationType.INFORMATION
)
notification.notify(null)
