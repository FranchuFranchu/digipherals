basically, to send the command ``set_pixel`` to a peripheral listening at channel ``channel1`` with the arguments ``3, 3, 5``

``digiline_send("channel1", {"set_pixel",3,3,5})`` on a connected luacontroller
