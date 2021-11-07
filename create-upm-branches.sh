git checkout $MAIN_BRANCH
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git subtree split -P "$PKG_ROOT_DIR_PATH" -b $UPM_BRANCH
git checkout $UPM_BRANCH
for file in $ROOT_FILES; do
    git checkout $MAIN_BRANCH $file &> /dev/null || echo $file is not found
    if [ -f $file ]; then
        cp package.json.meta $file.meta
        UUID=$(cat /proc/sys/kernel/random/uuid | tr -d '-')
        sed -i -e "s/guid:.*$/guid: $UUID/" $file.meta
        git add $file.meta
    fi
done
sed -i -e "s/\"version\":.*$/\"version\": \"$TAG\",/" package.json || echo package.json is not found
git mv $SAMPLES_DIR Samples~ &> /dev/null || echo $SAMPLES_DIR is not found
rm $SAMPLES_DIR.meta
git commit -m "release $TAG."
git push -f origin $UPM_BRANCH
git checkout -b $UPM_BRANCH@$TAG
git push -f origin $UPM_BRANCH@$TAG
