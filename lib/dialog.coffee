{$, TextEditorView, View} = require 'atom-space-pen-views'
path = require 'path'

module.exports =
class Dialog extends View
  @content: ({prompt} = {}) ->
    @div class: 'tree-view-dialog', =>
      @label prompt, class: 'icon', outlet: 'promptText'
      @subview 'miniEditor', new TextEditorView(mini: true)
      @div class: 'error-message', outlet: 'errorMessage'

  initialize: ({initialPath, select, iconClass} = {}) ->
    atom.commands.add @element,
      'core:confirm': => @onConfirm(@miniEditor.getText())
      'core:cancel': => @cancel()
    @miniEditor.on 'blur', => @close() if document.hasFocus()
    @miniEditor.getModel().onDidChange => @showError()

  attach: ->
    @panel = atom.workspace.addModalPanel(item: this.element)
    @miniEditor.focus()
    @miniEditor.getModel().scrollToCursorPosition()

  close: ->
    panelToDestroy = @panel
    @panel = null
    panelToDestroy?.destroy()
    atom.workspace.getActivePane().activate()

  cancel: ->
    @close()
    $('.tree-view').focus()

  showError: (message='') ->
    @errorMessage.text(message)
    @flashError() if message
