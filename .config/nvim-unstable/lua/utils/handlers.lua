local styles = {
    edge = {"default", "aura", "neon"},
    gruvbox = {"medium", "soft", "hard"},
    sonokai = {"default", "atlantis", "andromeda", "shusia", "maia"},
}

if Theming.colorscheme == nil or Theming.colorscheme:gsub("%s+", "") == "" then
    C = "edge"
else
    C = Theming.colorscheme:gsub("%s+", "")
end

if Theming.colorscheme_style ~= nil then
    CS = Theming.colorscheme_style:gsub("%s+", "")
    local function check_theme(theme)
        local style
        if theme == "edge" then
            style = styles.edge
        elseif theme == "gruvbox" then
            style = styles.gruvbox
        elseif theme == "sonokai" then
            style = styles.sonokai
        end
        if style ~= nil then
            if CS == "" or CS == nil then
                CS = style[1]
            end
        end
    end
    check_theme(C)
else
    CS = ""
end

-- Completion
if Completion.enabled == nil then
    Completion.enabled = true
end

if Completion.snippets == nil or Completion.snippets == true then
    Completion.snippets = {kind = " ﬌ "}
end

if Completion.lsp == nil or Completion.lsp == true then
    Completion.lsp = {kind = "  "}
end

if Completion.buffer == nil or Completion.buffer == true then
    Completion.buffer = {kind = "  "}
end

if Completion.path == nil or Completion.path == true then
    Completion.path = {kind = "  "}
end

if Completion.calc == nil or Completion.calc == true then
    Completion.calc = {kind = "   "}
end

if Completion.spell == nil or Completion.spell == true then
    Completion.spell = {kind = "  "}
end
