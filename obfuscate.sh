#! /bin/bash
HOME="/Users/netspider/Documents/workspace_pinpoint"
VERSION="1.0.2-SNAPSHOT"

echo "** Remove previous version"
#rm -fr $HOME/pinpoint-testbed/agent-obfuscated
rm -fr $HOME/pinpoint-testbed/agent-org
#mkdir $HOME/pinpoint-testbed/agent-obfuscated
mkdir $HOME/pinpoint-testbed/agent-org
echo "** ...OK"

echo "** Backup original(not obfuscated) bootstrap"
cp $HOME/pinpoint-testbed/agent/pinpoint-bootstrap-$VERSION.jar $HOME/pinpoint-testbed/agent-org/
rc=$?
if [[ $rc != 0 ]] ; then
        echo "** OBFUSCATION FAILED $rc"
        exit $rc
fi
echo "** ...OK"
echo "** Backup original(not obfuscated) profiler"
cp $HOME/pinpoint-testbed/agent/lib/pinpoint-profiler-$VERSION.jar $HOME/pinpoint-testbed/agent-org/
rc=$?
if [[ $rc != 0 ]] ; then
        echo "** OBFUSCATION FAILED $rc"
        exit $rc
fi
echo "** ...OK"
echo "** Backup original(not obfuscated) rpc"
cp $HOME/pinpoint-testbed/agent/lib/pinpoint-rpc-$VERSION.jar $HOME/pinpoint-testbed/agent-org/
rc=$?
if [[ $rc != 0 ]] ; then
        echo "** OBFUSCATION FAILED $rc"
        exit $rc
fi
echo "** ...OK"

echo ""
echo "** Run Proguard."
# osx : rt.jar -> /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes/classes.jar
RT_JAR="/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/lib/rt.jar"
proguard.sh -libraryjars $RT_JAR @proguard-$VERSION.conf
rc=$?
if [[ $rc != 0 ]] ; then
        echo "** OBFUSCATION FAILED $rc"
        exit $rc
fi
echo "** ...OK"
echo ""

echo "** Replace original bootstrap"
cp $HOME/pinpoint-bootstrap/target/pinpoint-bootstrap-$VERSION-obfuscated.jar $HOME/pinpoint-testbed/agent/pinpoint-bootstrap-$VERSION.jar
rc=$?
if [[ $rc != 0 ]] ; then
        echo "** OBFUSCATION FAILED $rc"
        exit $rc
fi
echo "** ...OK"

echo "** Replace original profiler"
cp $HOME/pinpoint-profiler/target/pinpoint-agent/lib/pinpoint-profiler-$VERSION-obfuscated.jar $HOME/pinpoint-testbed/agent/lib/pinpoint-profiler-$VERSION.jar
rc=$?
if [[ $rc != 0 ]] ; then
        echo "** OBFUSCATION FAILED $rc"
        exit $rc
fi
echo "** ...OK"

echo "** Replace original rpc lib"
cp $HOME/pinpoint-rpc/target/pinpoint-rpc-$VERSION-obfuscated.jar $HOME/pinpoint-testbed/agent/lib/pinpoint-rpc-$VERSION.jar
rc=$?
if [[ $rc != 0 ]] ; then
        echo "** OBFUSCATION FAILED $rc"
        exit $rc
fi
echo "** ...OK"

echo "** Copy mapping file"
cp $HOME/pinpoint-bootstrap/target/agent.map $HOME/pinpoint-testbed/agent/agent.map
rc=$?
if [[ $rc != 0 ]] ; then
        echo "** OBFUSCATION FAILED $rc"
        exit $rc
fi
echo "** ...OK"

echo ""
echo "** Original backup files"
ls -lR $HOME/pinpoint-testbed/agent-org

echo ""
echo "** Obfuscated agent files"
ls -lR $HOME/pinpoint-testbed/agent

echo ""
echo "** Everything is OK"