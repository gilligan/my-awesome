require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("revelation")
require("vicious")
require("blingbling")
require("blingbling.udisks_glue")
require("debian.menu")

local helpers = require("vicious.helpers")
local quake = require("quake")
local keydoc = require("keydoc")

--
-- [[ error handling ]]
--

do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
                       if in_error then return end
                       in_error = true

                       naughty.notify({ preset = naughty.config.presets.critical,
                                      title = "time to debug",
                                      text = err,
                                      screen = mouse.screen,
                                      timeout = 0 })
                       in_error = false
                   end)
                   end

                   --
                   -- [[ utilities ]]
                   --


                   function run_once(prg, args)
                       if not prg then
                           do return nil end
                       end
                       if not args then
                           args=""
                       end
                       awful.util.spawn_with_shell('pgrep -f -u $USER -x ' .. prg .. ' || (' .. prg .. ' ' .. args ..')')
                   end


                   --
                   -- [[ startup applications ]]
                   --
                   run_once("udisks-glue")
                   run_once("gnome-settings-daemon")
                   awful.util.spawn_with_shell("xset r rate 200 60")
                   -- awful.util.spawn_with_shell("xcompmgr")

                   --
                   -- [[ theme ]]
                   --

                   beautiful.init(awful.util.getdir("config") .. "/themes/nice-and-clean-theme/theme.lua")

                   --
                   -- [[ global variables ]]
                   --

                   homeDir         = os.getenv("HOME")
                   configDir       = awful.util.getdir("config")
                   blue 		= "#426797"
                   white 		= "#ffffff"
                   black 		= "#0a0a0b"
                   red             = "#d02e54"
                   green 		= "#16a712"
                   grey 		= "#6d7c80"
                   fontwidget 	= theme.font
                   space           = 32
                   icons           = configDir .. "/icons/"

                   naughty.config.default_preset.border_width     = 0
                   --
                   -- [[ default applications ]]
                   --

                   terminal    = "gnome-terminal"
                   editor      = gvim
                   editor      = os.getenv("EDITOR") or "editor"
                   editor_cmd  = terminal .. " -e " .. editor
                   browser     = "google-chrome"

                   --
                   -- [[ modifier key configuration ]]
                   --
                   modkey = "Mod4"
                   -- modkey = "#94"

                   --
                   -- [[ aliases ]]
                   --

                   exec		= awful.util.spawn
                   sexec		= awful.util.spawn_with_shell

                   --
                   -- [[ custome run-prompt ]]
                   --

                   myprompt	= "<span color='" .. red .. "'>></span>" ..
                   "<span color='" .. red .. "'>></span>" ..
                   "<span color='" .. red .. "'>> </span>"

                   --
                   -- [[ layouts to use ]]
                   --

                   layouts =
                   {
                       awful.layout.suit.tile,
                       awful.layout.suit.tile.left,
                       awful.layout.suit.tile.top,
                       awful.layout.suit.floating,
                       awful.layout.suit.max,
                   }

                   -- local quakeconsole = {}
                   -- for s = 1, screen.count() do
                   --   quakeconsole[s] = quake({ terminal = 'xterm',
                                                --			     height = 0.4,
                                                --			     screen = s })
                   --end


                   --
                   -- [[ specify tags ]]
                   --

                   tags = {}
                   tags[1] = awful.tag({'mail','web','chat','music','extra1'}, 1, layouts[1])
                   if screen.count() == 2 then
                       tags[2] = awful.tag({'vim','term','vm', 'file', 'extra2'}, 2, layouts[1])
                   end

                   --
                   -- [[ awesome menu ]]
                   --
                   myawesomemenu = {
                       { "manual", terminal .. " -e man awesome" },
                       { "edit config", editor_cmd .. " " .. awesome.conffile },
                       { "restart", awesome.restart },
                       { "quit", awesome.quit }
                   }

                   mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                           { "Debian", debian.menu.Debian_menu.Debian },
                                           { "open terminal", terminal }
                                       }
                                   })

                   mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                                      menu = mymainmenu })

                   udisks_glue=blingbling.udisks_glue.new(beautiful.udisks_glue)
                   udisks_glue:set_mount_icon(beautiful.accept)
                   udisks_glue:set_umount_icon(beautiful.cancel)
                   udisks_glue:set_detach_icon(beautiful.cancel)
                   udisks_glue:set_Usb_icon(beautiful.usb)
                   udisks_glue:set_Cdrom_icon(beautiful.cdrom)
                   awful.widget.layout.margins[udisks_glue.widget]= { top = 4}
                   udisks_glue.widget.resize= false


                   separator = widget({type="textbox"})
                   separator.text = " | "
                   spacer = widget({type="textbox"})
                   spacer.text = "     "

                   --
                   -- [[ clock widget  ]]
                   --

                   --mytextclock = awful.widget.textclock({ align = "right",}, "<span font_desc='" .. fontwidget .."'>" .. "%H:%M  " .. "</span>", 60)
                   mytextclock = awful.widget.textclock({ align = "right",}, "<span font_desc='" .. fontwidget .."'>" .. "%H:%M " .. "</span>", 60)

                   --
                   -- [[ keylayout widget  ]]
                   --

                   kbdcfg = {}
                   kbdcfg.cmd = "setxkbmap"
                   kbdcfg.layout = { "us", "de" }
                   kbdcfg.current = 1  -- us is our default layout
                   kbdcfg.widget = widget({ type = "textbox", align = "right" })
                   kbdcfg.widget.text = kbdcfg.layout[kbdcfg.current]
                   kbdcfg.switch = function ()
                       kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
                       local t = kbdcfg.layout[kbdcfg.current]
                       kbdcfg.widget.text = t
                       os.execute( kbdcfg.cmd .. t )
                   end
                   -- Mouse bindings
                   kbdcfg.widget:buttons(awful.util.table.join(
                       awful.button({ }, 1, function () kbdcfg.switch() end)
                       ))
                   kbdicon = widget({type = "imagebox"})
                   kbdicon.image = image(icons .. "bug.png")

                   --
                   -- [[ memory load widget  ]]
                   --

                   mymem = widget({ type = "textbox" })
                   mymem.width = 50
                   vicious.register(mymem, vicious.widgets.mem, function (widget, args)
                                    local num = string.format("%02d",args[1])
                                    return "<span font_desc='" .. fontwidget .."'>mem:" .. num .. "%" .. "</span>"
                                end
                                , 30)

                   --
                   -- [[ cpu load widget ]]
                   --

                   mycpuload = widget({ type = "textbox" })
                   vicious.register(mycpuload, vicious.widgets.cpu, function (widget, args)
                                    local num = string.format("%02d",args[1])
                                    return "<span font_desc='" .. fontwidget .."'>cpu:" .. num .. "%" .. "</span>"
                                end
                                , 5)
                   mycpuload.width = 50
                   -- mycpuloadicon = widget({ type = "imagebox" })
                   -- mycpuloadicon.image = image(icons .. "cpu.png")

                   --
                   -- [[ spotify widget ]]
                   --

                   spotifywidget = widget({type = "textbox" })
                   vicious.register( spotifywidget, vicious.widgets.spotify, function ( widget, args)
                                    if args["{State}"] == 'Playing' then
                                        local info = args["{Artist}"] .. ':' .. args["{Title}"]
                                        return helpers.escape(info:gsub("^%s*(.-)%s*$","%1"))
                                    else
                                        return ""
                                    end
                                end, 2)

                   --
                   -- [[ systray widget ]]
                   --

                   mysystray = widget({ type = "systray" })


                   --
                   -- [[ setup widgets in wibox ]]
                   --

                   mywibox = {}
                   mypromptbox = {}
                   mylayoutbox = {}
                   mytaglist = {}


                   mytaglist.buttons = awful.util.table.join(
                       awful.button({ }, 1, awful.tag.viewonly),
                       awful.button({ modkey }, 1, awful.client.movetotag),
                       awful.button({ }, 3, awful.tag.viewtoggle),
                       awful.button({ modkey }, 3, awful.client.toggletag),
                       awful.button({ }, 4, awful.tag.viewnext),
                       awful.button({ }, 5, awful.tag.viewprev)
                       )


                   mytasklist = {}
                   mytasklist.buttons = awful.util.table.join(
                       awful.button({ }, 1, function (c)
                                    if c == client.focus then
                                        c.minimized = true
                                    else
                                        if not c:isvisible() then
                                            awful.tag.viewonly(c:tags()[1])
                                        end
                                        -- This will also un-minimize
                                        -- the client, if needed
                                        client.focus = c
                                        c:raise()
                                    end
                                end),
                   awful.button({ }, 3, function ()
                                if instance then
                                    instance:hide()
                                    instance = nil
                                else
                                    instance = awful.menu.clients({ width=250 })
                                end
                            end),
                   awful.button({ }, 4, function ()
                                awful.client.focus.byidx(1)
                                if client.focus then client.focus:raise() end
                            end),
                   awful.button({ }, 5, function ()
                                awful.client.focus.byidx(-1)
                                if client.focus then client.focus:raise() end
                            end))

                   --
                   -- set up all tags
                   --
                   for s = 1, screen.count() do

                       mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright, prompt = myprompt })
                       mylayoutbox[s] = awful.widget.layoutbox(s)
                       mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
                       mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

                       -- disable tasklist for now, might want it back later though ? ..

                       --mytasklist[s] = awful.widget.tasklist(function(c)
                                                               --return awful.widget.tasklist.label.currenttags(c, s)
                                                               --end, mytasklist.buttons)

                       mywibox[s] = awful.wibox({ position = "top", screen = s, height= 24 })
                       mywibox[s].widgets = {
                           {
                               mylauncher,
                               mytaglist[s],
                               mypromptbox[s],
                               layout = awful.widget.layout.horizontal.leftright
                           },
                           mylayoutbox[s],
                           mytextclock,
                           separator,
                           mymem,
                           separator,
                           mycpuload,
                           separator,
                           kbdcfg.widget,
                           separator,
                           spotifywidget,
                           spacer,
                           udisks_glue.widget,
                           s == 1 and mysystray or nil,
                           --mytasklist[s],
                           layout = awful.widget.layout.horizontal.rightleft,
                       }
                   end

                   --
                   --  Mouse bindings
                   --
                   root.buttons(awful.util.table.join(
                       awful.button({ }, 3, function () mymainmenu:toggle() end),
                       awful.button({ }, 4, awful.tag.viewnext),
                       awful.button({ }, 5, awful.tag.viewprev)
                       ))



                   --
                   -- [[ global key mappings ]]
                   --

                   globalkeys = awful.util.table.join(

                       keydoc.group("Layout manipulation"),

                       awful.key({ modkey,           }, "F1",   keydoc.display),

                       -- mapping: <mod>-<left>  : move to tag on the left
                       awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
                                 "Move to tag on the left"       ),

                       -- mapping: <mod>-<right> : move to tag on the right
                       awful.key({ modkey,           }, "Right",  awful.tag.viewnext
                                 "Move to tag on the right"       ),

                       -- mapping: <mod>-<esc>   : move to previous tag
                       awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
                                 "Move to previous tag"),

                       -- mapping: <mod>-e       : mac-style expose function
                       awful.key({ modkey,           }, "e", revelation,
                                 "Toggle revelation"),

                       -- mapping: <mod>-j       : move to next client
                       awful.key({ modkey,           }, "j",
                                 function ()
                                     awful.client.focus.byidx( 1)
                                     if client.focus then client.focus:raise() end
                                 end,
                                 "Move to next client"),

                       -- mapping: <mod>-j       : move to previous client
                       awful.key({ modkey,           }, "k",
                                 function ()
                                     awful.client.focus.byidx(-1)
                                     if client.focus then client.focus:raise() end
                                 end,
                                 "Move to previous client"),

                       -- mapping: <mod>-w       : show popup menu
                       awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end,
                                 "Show popup menu"),

                       -- mapping: <mod>-<shift>-j : swap with previous client
                       awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
                                 "Swap with previous client"),

                       -- mapping: <mod>-<shift>-k : swap with next client
                       awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
                                 "Swap with next client"),

                       -- mapping: <mod>-<ctrl>-j : swap with next client
                       awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
                                 "Swap with next client"),

                       -- mapping: <mod>-<ctrl>-k : swap with previous client
                       awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
                                 "Swap with previous client"),

                       -- mapping: <mod>-u        : jump to urgent client
                       awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
                                 "Jump to urgent client"),

                       -- mapping: <mod>-<tab>    : go to previous client
                       awful.key({ modkey,           }, "Tab",
                                 function ()
                                     awful.client.focus.history.previous()
                                     if client.focus then
                                         client.focus:raise()
                                     end
                                 end,
                                 "Jump to previous client"),

                       keydoc.group("Misc"),

                       awful.key({modkey}, "t", function ()
                                 -- If you want to always position the menu on the same place set coordinates
                                 awful.menu.menu_keys.down = { "Down", "j" }
                                 awful.menu.menu_keys.up = { "Down", "k" }
                                 local cmenu = awful.menu.clients({width=245}, { keygrabber=true, coords={x=525, y=330} })
                             end),

                       -- mapping: <mod>-<CR>     : open default terminal
                       awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end,
                                 "Open Terminal"),

                       -- mapping: <mod>-<ctrl>-r : restart awesome
                       awful.key({ modkey, "Control" }, "r", awesome.restart,
                                 "Restart awesome"),

                       -- mapping: <mod>-<shift>-q : quit awesome
                       awful.key({ modkey, "Shift"   }, "q", awesome.quit,
                                 "Quit awesome"),
                       awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end, ""),
                       awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end, ""),
                       awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end, ""),
                       awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end, ""),
                       awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end, ""),
                       awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end, ""),
                       awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end, ""),
                       awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end, ""),
                       awful.key({ modkey, "Control" }, "n", awful.client.restore, "Restore Client"),

                       awful.key({modkey}, "[", function () sexec("sh ~/.config/awesome/extra/vol.sh down" ) end,
                                 "Increase Volume"),
                       awful.key({modkey}, "]", function () sexec("sh ~/.config/awesome/extra/vol.sh up") end,
                                 "Decrease Volume"),

                       awful.key({modkey}, "\;", function () sexec("sh ~/.config/awesome/extra/spotify-prev.sh") end,
                                 "Spotify:Next"),
                       awful.key({modkey}, "\'", function () sexec("sh ~/.config/awesome/extra/spotify-next.sh") end,
                                 "Spotify:Previous"),

                       awful.key({modkey}, "`", function () quakeconsole[mouse.screen]:toggle() end,
                                 "Toggle Quake Console"),
                       awful.key({modkey}, "r", function () mypromptbox[mouse.screen]:run() end,
                                 "Toggle Run Prompt"),
                       awful.key({ modkey }, "x",
                                 function ()
                                     awful.prompt.run({ prompt = "Run Lua code: " },
                                                      mypromptbox[mouse.screen].widget,
                                                      awful.util.eval, nil,
                                                      awful.util.getdir("cache") .. "/history_eval")
                                 end,
                                 "Run Lua Code")
                                     )

                                     clientkeys = awful.util.table.join(
                                         awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end,
                                                   "Toggle Fullscreen"),
                                     awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
                                               "Kill Client"),
                                     awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
                                               "Toggle Float"),
                                     awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                                               "Swap with master client"),
                                     awful.key({ modkey,           }, "o",      awful.client.movetoscreen,
                                               "Move to next screen"),
                                     awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end,
                                               "Redraw client"),
                                     awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                                               "Put on top"),
                                     awful.key({ modkey,           }, "n",
                                               function (c)
                                                   -- The client currently has the input focus, so it cannot be
                                                   -- minimized, since minimized clients can't have the focus.
                                                   c.minimized = true
                                               end,
                                               "Minimize client"),
                                     awful.key({ modkey,           }, "m",
                                               function (c)
                                                   c.maximized_horizontal = not c.maximized_horizontal
                                                   c.maximized_vertical   = not c.maximized_vertical
                                               end,
                                               "Maximize client")
                                     )

                                     -- Compute the maximum number of digit we need, limited to 9
                                     keynumber = 0
                                     for s = 1, screen.count() do
                                         keynumber = math.min(9, math.max(#tags[s], keynumber));
                                     end

                                     -- Bind all key numbers to tags.
                                     -- Be careful: we use keycodes to make it works on any keyboard layout.
                                     -- This should map on the top row of your keyboard, usually 1 to 9.
                                     for i = 1, keynumber do
                                         globalkeys = awful.util.table.join(globalkeys,
                                                                            awful.key({ modkey }, "#" .. i + 9,
                                                                                      function ()
                                                                                          local screen = mouse.screen
                                                                                          if tags[screen][i] then
                                                                                              awful.tag.viewonly(tags[screen][i])
                                                                                          end
                                                                                      end, ""),
                                                                            awful.key({ modkey, "Control" }, "#" .. i + 9,
                                                                                      function ()
                                                                                          local screen = mouse.screen
                                                                                          if tags[screen][i] then
                                                                                              awful.tag.viewtoggle(tags[screen][i])
                                                                                          end
                                                                                      end, ""),
                                                                            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                                                                                      function ()
                                                                                          if client.focus and tags[client.focus.screen][i] then
                                                                                              awful.client.movetotag(tags[client.focus.screen][i])
                                                                                          end
                                                                                      end, ""),
                                                                            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                                                                      function ()
                                                                                          if client.focus and tags[client.focus.screen][i] then
                                                                                              awful.client.toggletag(tags[client.focus.screen][i])
                                                                                          end
                                                                                      end, ""))
                                                                        end

                                                                        clientbuttons = awful.util.table.join(
                                                                            awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
                                                                            awful.button({ modkey }, 1, awful.mouse.client.move),
                                                                            awful.button({ modkey }, 3, awful.mouse.client.resize))

                                                                        -- Set keys
                                                                        root.keys(globalkeys)
                                                                        --

                                                                        --  Rules
                                                                        awful.rules.rules = {
                                                                            -- All clients will match this rule.
                                                                            { rule = { },
                                                                            properties = { border_width = beautiful.border_width,
                                                                            border_color = beautiful.border_normal,
                                                                            focus = true,
                                                                            keys = clientkeys,
                                                                            buttons = clientbuttons,
                                                                            size_hints_honor = false } },
                                                                            { rule = { class = "MPlayer" },
                                                                            properties = { floating = true } },
                                                                            { rule = { class = "gimp" },
                                                                            properties = { floating = true } },
                                                                            { rule = { class = "XTerm" },
                                                                            properties = { opacity = 0.8,
                                                                            size_hints_honor = false } },
                                                                            { rule = { class = "Gvim" },
                                                                            properties = { size_hints_honor = false } },
                                                                        }
                                                                        --

                                                                        --  Signals
                                                                        -- Signal function to execute when a new client appears.
                                                                        client.add_signal("manage", function (c, startup)
                                                                                          -- Add a titlebar
                                                                                          -- awful.titlebar.add(c, { modkey = modkey })

                                                                                          -- Enable sloppy focus
                                                                                          c:add_signal("mouse::enter", function(c)
                                                                                                       if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                                                                                                           and awful.client.focus.filter(c) then
                                                                                                           client.focus = c
                                                                                                       end
                                                                                                   end)

                                                                        if not startup then
                                                                            -- Set the windows at the slave,
                                                                            -- i.e. put it at the end of others instead of setting it master.
                                                                            -- awful.client.setslave(c)

                                                                            -- Put windows in a smart way, only if they does not set an initial position.
                                                                            if not c.size_hints.user_position and not c.size_hints.program_position then
                                                                                awful.placement.no_overlap(c)
                                                                                awful.placement.no_offscreen(c)
                                                                            end
                                                                        end
                                                                    end)

                                                                        client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
                                                                        client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

                                                                        -- naughty notifications
                                                                        function closeLastNoti()
                                                                            screen = mouse.screen
                                                                            for p,pos in pairs(naughty.notifications[screen]) do
                                                                                for i,n in pairs(naughty.notifications[screen][p]) do
                                                                                    if (n.width == 258) then -- to close only previous bright/vol notifications
                                                                                        naughty.destroy(n)
                                                                                        break
                                                                                    end
                                                                                end
                                                                            end
                                                                        end

                                                                        -- volume notification

                                                                        volnotiicon = nil
                                                                        function volnoti()
                                                                            closeLastNoti()
                                                                            naughty.notify{
                                                                                icon = volnotiicon,
                                                                                position = "top_right",
                                                                                fg=black,
                                                                                bg=blue,
                                                                                border_color = blue,
                                                                                timeout=1,
                                                                                width = 245,
                                                                                screen = mouse.screen,
                                                                            }
                                                                        end

                                                                        function run_or_raise(cmd, properties)
                                                                            local clients = client.get()
                                                                            local focused = awful.client.next(0)
                                                                            local findex = 0
                                                                            local matched_clients = {}
                                                                            local n = 0
                                                                            for i, c in pairs(clients) do
                                                                                --make an array of matched clients
                                                                                if match(properties, c) then
                                                                                    n = n + 1
                                                                                    matched_clients[n] = c
                                                                                    if c == focused then
                                                                                        findex = n
                                                                                    end
                                                                                end
                                                                            end
                                                                            if n > 0 then
                                                                                local c = matched_clients[1]
                                                                                -- if the focused window matched switch focus to next in list
                                                                                if 0 < findex and findex < n then
                                                                                    c = matched_clients[findex+1]
                                                                                end
                                                                                local ctags = c:tags()
                                                                                if table.getn(ctags) == 0 then
                                                                                    -- ctags is empty, show client on current tag
                                                                                    local curtag = awful.tag.selected()
                                                                                    awful.client.movetotag(curtag, c)
                                                                                else
                                                                                    -- Otherwise, pop to first tag client is visible on
                                                                                    awful.tag.viewonly(ctags[1])
                                                                                end
                                                                                -- And then focus the client
                                                                                client.focus = c
                                                                                c:raise()
                                                                                return
                                                                            end
                                                                            awful.util.spawn(cmd)
                                                                        end
