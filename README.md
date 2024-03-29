# What is Wexlfu?
Wexlfu (Wesnoth EXtension Library For Utility) is essentially a library of code and data to be shared among campaigns.

# Release Scheme
* Git tags: `v<major>.<minor>.<sub>`
  * Major versions indicate major breaking changes.
  * Minor versions indicate major backward-compatible changes.
  * Sub versions indicate minor changes.
* Git branches: `release-<major>`
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
# Wexlfu configuration lines.

# Campaign directory name.
#NAME No_Name

# Macro prefix (for things like NN_DATAPATH).
#MACRO NN

# For more configuration variables, see tools/campaign_variables.sh

{./dist/wexlfu_preload.cfg}

[campaign]
# Campaign definition here....
{WEXLFU_CAMPAIGN}
[/campaign]

#ifdef CAMPAIGN_NO_NAME
{./dist/wexlfu_load.cfg}
#endif
```

You must then run `tools/build_campaign.sh` in your campaign's directory to create the files.
