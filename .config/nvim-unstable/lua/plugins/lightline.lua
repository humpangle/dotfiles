local l = {}

l.component_function = {
    git = "LightlineFugitive",
    filename = "LightlineFilename",
}

l.active = {
    left = {{"mode", "paste"}, {"git", "readonly", "filename", "modified"}},
}

l.tab_component_function = {
    filename_active = 'LightlineFilenameTab',
}

l.tab = {
    active = {"tabnum", "filename", "modified"},
    inactive = {"tabnum", "filename_active", "modified"},
}

Vimg.lightline = l
