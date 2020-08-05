#!/bin/bash

# sleepy's minecraft server running script!
# use with https://github.com/agowa338/MinecraftSystemdUnit !
# because systemd doesn't like me :(((
# more like i needed to open a specific forge(blah).jar version but instead it opened minecraft_server(blah).jar
# or wrong forge version

# systemd should have set the other variables. if it didn't ill cry :(

# TODO: (maybe) use tmux, tmux is better. I'll fangirl tumx any day.

MC_JAVA_ARGS="-XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC \
          -XX:+UseParNewGC -XX:+UseNUMA -XX:+CMSParallelRemarkEnabled \
          -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 \
          -XX:GCPauseIntervalMillis=150 -XX:+UseAdaptiveGCBoundary \
          -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 \
          -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 \
          -Dfml.ignorePatchDiscrepancies=true \
          -Dfml.ignoreInvalidMinecraftCertificates=true \
          -XX:+UseFastAccessorMethods -XX:+UseCompressedOops \
          -XX:+OptimizeStringConcat -XX:+AggressiveOpts \
          -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing \
          -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10"

if [[ -z ${MC_SERVER_JAR_FILE+x} ]]; then
    MC_SERVER_JAR_FILE=$(find -L . \
               -maxdepth 1 \
               -type f \
               -iregex ".*/\\(FTBServer\\|craftbukkit\\|spigot\\|paper\\|forge\\|minecraft_server\\).*jar")
fi

if [[ -z ${1+x} ]]; then
    echo "environment (folder) not set!" 1>&2
    exit 1
fi

echo "main-run-server.sh (PRE-INIT)"
echo "server at ${PWD}"
echo "using ${MC_SERVER_JAR_FILE}"
echo "using environment name $1"
echo "launching server!"

/usr/bin/tail -F /srv/games/minecraft/${1}/logs/latest.log &

/usr/bin/screen -DmS mc-${1} \
        /usr/bin/java \
            -server \
            -Xmx${MC_MAX_MEM} \
            ${MC_JAVA_ARGS} \
            -jar ${MC_SERVER_JAR_FILE} nogui; exit
