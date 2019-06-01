# What is Wexlfu?
Wexlfu (Wesnoth EXtension Library For Utility) is essentially a library of code and data to be shared among campaigns.

# Release Scheme
* Git tags: v<major>.<minor>.<sub>
 * Major versions indicate major breaking changes.
 * Minor versions indicate major backward-compatible changes.
 * Sub versions indicate minor changes.
* Git branches: release-<major>
 * Release branches update with the latest backward-compatible changes.
 * The master branch may break backward-compatability.

# Why make a library?
I dislike copy-and-paste styles of sharing resources. A library nicely contradicts this and allows me to focus on things other than pasting the same resources multiple times.

# Why does this library includes story elements (custom units, a timeline, etc.)?
Developing more campaigns in the future that are set in the same timeline and feature the same characters or organizations appeals to me, so Wexlfu also contains the resources to easily and simply share history between add-ons.

# I want to develop a campaign using this library!
Wow, really?

To install Wexlfu with your add-on, just add it as a git submodule (or similiarly install it within your add-on's directory).
You can then use code similiar to this in _main.cfg (note that this will use a Wexlfu installed in the top-level add-ons directory first, if it is available):

```
# Wexlfu configuration lines with default settings.

# Campaign directory name.
#NAME No_Name

# Macro prefix (for things like NN_DATAPATH).
#MACRO NN

# Required wexlfu major version (will default to version that runs build_campaign.sh).
#WEXLFU 4

# Require minor and sub version or greater (examples would match anything from 4.0.0 up to but excluding 5.0.0).
#WEXLFU_SUB 0.0

# Place where the global Wexlfu may be installed.
#GLOBAL_WEXLFU_BINARY_PATH data/add-ons/Wexlfu
#GLOBAL_WEXLFU_PREFIX ~add-ons/Wexlfu

# Directory where the local Wexlfu may be installed.
#LOCAL_WEXLFU Wexlfu

# Parent directory of the campaign.
#PARENT_DATA data/add-ons
#PARENT_LOAD ~add-ons

{./wexlfu_preload.cfg}

# Campaign definition here....

#ifdef CAMPAIGN_NO_NAME
{./wexlfu_load.cfg}
#endif

#ifdef EDITOR
{./wexlfu_load.cfg}
#endif

```

You must then run tools/build_campaign.sh in your campaign's directory to create the files.
