local awful = require('awful')

function create_keyboard_layout(s)
    return awful.widget.keyboardlayout {
        screen = s
    }
end

return create_keyboard_layout
