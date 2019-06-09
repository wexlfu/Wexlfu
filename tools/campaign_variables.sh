# If not otherwise specified, variables are read from _main.cfg as (example): `#NAME: No_Name`

# Markdown list of campaign information.
# Constructed automatically.
dvar CAMPAIGN_STATS ""
# Plain text for insertion in description.
dvar CAMPAIGN_STATS_PLAIN ""

# The campaign description.
# Read from [campaign].description
dvar DESCRIPTION ""

# Read from secrets/email.ign
dvar EMAIL ""

# Where to search for the global Wexlfu?
dvar GLOBAL_WEXLFU_BINARY_PATH "data/add-ons/Wexlfu"
dvar GLOBAL_WEXLFU_PREFIX "~add-ons/Wexlfu"

# The add-on's icon.
# Read from icon.png as a data url if it exists, otherwise from [campaign].icon
dvar ICON ""

# The directory of Wexlfu included within the addon.
dvar LOCAL_WEXLFU "Wexlfu"

# The campaign's macro prefix (for e.g. NN_DATAPATH).
dvar MACRO NN

# Possible medals that can be earned.
dvar META_MEDALS 0
# Number of planned active (battle) scenarios.
dvar META_SCENARIOS 0
# Number of playable scenarios.
dvar META_SCENARIOS_DONE 0

# The campaign's directory name.
dvar NAME No_Name

# Where is the campaign's directory located?
dvar PARENT_DATA "data/add-ons"
dvar PARENT_LOAD "~add-ons"

# Read from secrets/passphrase.ign
dvar PASSPHRASE ""

# Read from _main.cfg automatically.
dvar TEXTDOMAIN "wesnoth-No_Name"

# Required Wexlfu major version.
dvar WEXLFU "$(cat "$wx"/VERSION | cut -d. -f1)"
# Minimum Wexlfu version (minor and sub, last two numbers). (To require 4.0.3, set WEXLFU to 4 and WEXLFU_SUB to 0.3).
dvar WEXLFU_SUB "$(cat "$wx"/VERSION | cut -d. -f2-)"

# Read from VERSION
dvar VERSION "0.0.0"
