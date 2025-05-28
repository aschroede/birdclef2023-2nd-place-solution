#!/bin/bash

# ---- Load Environment Variables ----

# set variable to path where this script is
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR" || exit 1

# load the environment variables from the `.env` file
source ../.env 2> /dev/null || source .env

# check $NFS_USER_DIR and $PROJECT_NAME are defined in the .env file
if [ -z "$NFS_USER_DIR" ]; then
    echo "Please set $NFS_USER_DIR in .env file."
    exit
fi
if [ -z "$PROJECT_NAME" ]; then
    echo "Please set $PROJECT_NAME in .env file."
    exit
fi

echo "using NFS_USER_DIR=$NFS_USER_DIR and PROJECT_NAME=$PROJECT_NAME"




# CLUSTER_BASE should point towards: /vol/csedu-nobackup/course/IMC030_mlip/${USER}
CLUSTER_BASE="$NFS_USER_DIR"/"$PROJECT_NAME"


#!/bin/bash
PROJECT_ROOT="$( dirname "$SCRIPT_DIR" )"
LINK_FILE="$SCRIPT_DIR/.clusterlink"


#!/bin/bash

# Get script and project root locations
LINK_FILE="$SCRIPT_DIR/.clusterlink"

echo "Preparing cluster links using $LINK_FILE"

if [ ! -f "$LINK_FILE" ]; then
  echo "❌ No .clusterlink file found at $LINK_FILE. Skipping setup."
  exit 1
fi

cd "$PROJECT_ROOT" || {
  echo "❌ Could not change to project root: $PROJECT_ROOT"
  exit 1
}

while IFS=: read -r link_name target_rel; do
  [[ "$link_name" =~ ^#.*$ || -z "$link_name" ]] && continue

  TARGET="$CLUSTER_BASE/$target_rel"
  echo "→ Processing: $link_name → $TARGET"

  if [ -d "$link_name" ] && [ ! -L "$link_name" ]; then
    echo "   - Copying $link_name/ structure into $TARGET"
    mkdir -p "$TARGET"
    cd "$link_name"
    find . -type d -exec mkdir -p "$TARGET/{}" \;
    find . -name '.gitignore' -exec cp --parents {} "$TARGET/" \;
    cd "$PROJECT_ROOT" || {
      echo "   ❌ Failed to return to project root — aborting."
      exit 1
    }
    echo "   - Removing $link_name/ and replacing with symlink"
    rm -rf "$link_name"
    ln -s "$TARGET" "$link_name"

  elif [ -L "$link_name" ]; then
    echo "   - $link_name is already a symlink — replacing"
    rm "$link_name"
    ln -s "$TARGET" "$link_name"

  elif [ -d "$link_name" ]; then
    echo "   - Removing existing $link_name/ directory and replacing with symlink"
    rm -rf "$link_name"
    ln -s "$TARGET" "$link_name"

  elif [ ! -e "$link_name" ]; then
    echo "   - Creating new symlink: $link_name → $TARGET"
    ln -s "$TARGET" "$link_name"

  else
    echo "   ⚠️  $link_name exists and is not a directory or symlink — skipping"
  fi

done < "$LINK_FILE"

echo "✅ Done."