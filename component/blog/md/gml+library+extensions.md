# Preface

This post goes into detail about an undocumented feature of GML originally brought to my attention by [Zach Reedy](https://twitter.com/datzach). Since this feature is undocumented it wouldn't be wise to depend entirely on any topics discussed throughout this post in case something changes in the future, or if there are inconsistencies between target platforms.

# The Problem

Like many libraries, there are gaps in the set of built-in functions provided by GameMaker. This is typically due to niche functionality having a low-priority; for instance, there exists functions for setting the minimum and maximum size of the game window[^windowf], but no functions for getting these values back in case they were updated somewhere else in the codebase.

One method to circumvent this would be to maintain a global variable that stores the current minimum and maximum size of the window; these global variables could then be accessed in order to obtain the current window size. The following snippet of code illustrates how such an approach would work by implementing a helper function `set_min_size` that sets the minimum size of the window, whilst also keeping track of these sizes in corresponding global variables `windowMinWidth` and `windowMinHeight`:

```gml
global.windowMinWidth  = -1;
global.windowMinHeight = -1;

function set_min_size(_width, _height) {
  window_set_min_width(_width);
  window_set_min_height(_height);
  global.windowMinWidth  = _width;
  global.windowMinHeight = _height;
}
```

However, this approach only works well if you have trust in yourself and your collaborators to maintain synchronisation between the global variables and the actual window size. This ultimately requires prohibiting the use of both `window_set_min_width` and `window_set_min_height` by team members; any violation of this rule would result in difficult to track bugs.

# The Solution

An alternative approach to this problem is to use macros to override existing built-in functions whilst preserving a reference to the original function. In other words, opaquely extending existing built-in functions with additional behaviour, such that upon calling `window_set_min_width` the associated global variable, `windowMinWidth`, would be automatically updated:

```gml
window_set_min_width(100);  // automatically updates `windowMinWidth` to 100
window_set_min_height(100); // automatically updates `windowMinHeight` to 100
```

This is superior in some ways to the previous approach because it does not prohibit the use of `window_set_min_width` and `window_set_min_height`. Everything the `set_min_size` function did is being performed behind the scenes for the user.

## Implementation Details

As shown in a [previous blog post](./gml+syntax+extensions.html) built-in functions and variables can be overrided using macros. However, the method discussed in that post was limited because it made the original reference to the built-in function unreachable. As a result, the original behaviour of the function was lost. This is not ideal because the goal is add additional functionality to existing built-in functions, not replace their functionality entirely; therefore, a method of preserving the reference to the original built-in function is required.

The method discussed in this section extends the one discussed in the previous post by including an additional macro that gives a new alias to built-in function that can be used later. Consider the example presented for the method in the previous post:

```gml
#macro show_debug_message overrides_show_debug_message

function overrides_show_debug_message(_str) {
  var file = file_text_open_append("game.log");
  file_text_write_string(file, _str);
  file_text_writeln(file);
  file_text_close(file);
}
```

The `show_debug_message` typically displays a message in the console window; this example will override the `show_debug_message` function with a custom implementation that appends the message to a log file. This results in no debug messages being displayed in the console window, since the original behaviour of the function is lost. Using an additional macro the function definition can be updated such that both the original and custom implementations of the function are performed:

```gml
#macro BUILTIN_SHOW_DEBUG_MESSAGE show_debug_message
#macro show_debug_message overrides_show_debug_message

function overrides_show_debug_message(_str) {
  BUILTIN_SHOW_DEBUG_MESSAGE(_str); // call the original implementation
  var file = file_text_open_append("game.log");
  file_text_write_string(file, _str);
  file_text_writeln(file);
  file_text_close(file);
}
```

The macro `BUILTIN_SHOW_DEBUG_MESSAGE` is included that creates a new alias for the `show_debug_message` function. This alias is then used within the `overrides_show_debug_message` function in order to call the original implementation. As a result, the `show_debug_message` function will first display the message to the console before writing it to the log file.

Applying this technique to the window example, the following code can be produced:

```gml
// preserve the original built-in function references
#macro BUILTIN_WINDOW_SET_MIN_WIDTH  window_set_min_width
#macro BUILTIN_WINDOW_SET_MIN_HEIGHT window_set_min_height

// override the current function with a custom user-defined function
#macro window_set_min_width  overrides_window_set_min_width
#macro window_set_min_height overrides_window_set_min_height

global.windowMinWidth  = -1;
global.windowMinHeight = -1;

// implement function overrides
function overrides_window_set_min_width(_width) {
  BUILTIN_WINDOW_SET_MIN_WIDTH(_width); // call the built-in reference
  global.windowMinWidth = _width;       // update internal record
}
function overrides_window_set_min_height(_height) {
  BUILTIN_WINDOW_SET_MIN_HEIGHT(_height);
  global.windowMinHeight = _height;
}
```

Using the `window_set_min_width` and `window_set_min_height` functions will now automatically update their corresponding global variables, without any additional functions from the perspective of the library user.

## Hiding Implementation Details

Although not strictly required for the method, in interest of making it difficult to de-synchronise the global variables, the public interface available to team members can be restricted. For example, verbose names could be given to the global variables. Their values can then be exposed using shorter, more appealing user-defined getter functions `window_get_min_width` and `window_get_min_height`:

```gml
global.__internalWindowVariable_windowMinWidth  = -1;
global.__internalWindowVariable_windowMinHeight = -1;

function window_get_min_width() {
  return global.__internalWindowVariable_windowMinWidth;
}
function window_get_min_height() {
  return global.__internalWindowVariable_windowMinHeight;
}
```

Since getter functions return a copy of the values stored in the global variables, there is no risk of accidentally modifying the global variables. This essentially reduces the likelihood of a team member making a mistake, by increasing the effort required to type out the names of protected global variables. This same method could be applied to the macro definitions and function overides in order to coerce users into only using the getter and setter functions.

Additionally, since many auto complete engines sort underscores alphabetically after letters, any identifiers starting with an underscore will usually appear at the end of the list. This further increases the effort required to make a mistake when using the library.

# Experiments

A few experiments have been created that extend the GameMaker standard library, and can be found on [GitHub](https://github.com/NuxiiGit/macro-hacks). A list of functions that have been added include:

 - `application_set_position` -- Enables setting an exact region to render the application surface.
 - `application_set_position_fixed` -- Similar to `application_set_position`, except preserving aspect ratio.
 - `display_set_gui_position` -- Enables setting an exact region and scale to draw the GUI in.
 - `network_get_config` -- Enables getting network configurations set by the user.

Functions such as `display_set_gui_position` and `network_get_config` have seen practical use in project I've been a part of. Additionally, `display_set_gui_position` lifts a restriction of the current GUI functions where only an offset *or* scale could be set, but not both simultaneously.

Also included in the repository is a singleton system, which overrides the built-in instance functions in order to prevent multiple singletons from being created, and to offer deactivation immunity to system objects. This can help reduce the likelihood of bugs related to system objects from occurring.

# Summary

This post has discussed an interesting undocumented feature of macros, and how they can be used to fill gaps within the GameMaker standard library. This approach also shows promise in reducing potential bugs by hiding the job of synchronising global variables with inputs to built-in functions.

# References

[^windowf]: <%= ref({
    :author => "YoYo Games Ltd",
    :title => "10.2.6.2 - The Game Window",
    :booktitle => "GameMaker Studio 2 Manual",
    :year => "2021",
    :url => "https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Cameras_And_Display/The_Game_Window/The_Game_Window.htm",
    :visitedon => "2021-06-08"
}) %>
