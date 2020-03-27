minetest.register_tool("digipherals:pointer", {
    description = "Pointer",
    inventory_image = "digipherals_pointer.png",

    on_use = digipherals.helpers.pointer.on_use,
})