#!/bin/bash

# inspired from the evaluate_corpus_tempeval3style.sh script available at
# https://github.com/HeidelTime/heideltime/wiki/Reproducing-Evaluation-Results

if [ $# -lt 3 ]
then
    echo "Error in $0 - Invalid Argument Count"
    echo "Syntax: $0 <corpus name> <EVALPATH> <HEIDELTIMEEVALPATH"
    echo "with corpus name: wikiwarsua"
    exit
fi

if [ "$1" = "wikiwarsua" ]
then
    echo "Evaluation corpus: $1"
else
    echo "Corpus name not correct: Choose one of the following corpora: wikiwarsua"
    exit
fi

function abspath {
	if [[ -d "$1" ]]
	then
		pushd "$1" >/dev/null
		pwd
		popd >/dev/null
	elif [[ -e $1 ]]
	then
		pushd $(dirname $1) >/dev/null
		echo $(pwd)/$(basename $1)
		popd >/dev/null
	else
		echo $1 does not exist! >&2
		return 127
	fi
}

CORPUS=$1
EVALPATH="$(abspath "$2")"
HDLTEVALPATH="$(abspath "$3")"

#################
# Set Variables #
#################
PATHCORPUS=$EVALPATH
PATHEVAL="$EVALPATH/evaluation_results/$CORPUS"
PATHOUTPUT="$EVALPATH/uima_output/$CORPUS"
WORKFLOWENDING=_workflow.xml
PATHWORKFLOW="$EVALPATH/uima_workflows/$CORPUS$WORKFLOWENDING"
PATHSCRIPTS="$HDLTEVALPATH/scripts"

if [ "$CORPUS" = "wikiwarsua" ]
then
        PATHCORPUS=$EVALPATH/corpora/WikiWarsUA/timeml
fi


###########################################################
# 0. Remove old evaluation results and create directories #
###########################################################
if [ ! -d $PATHEVAL ]
then
    /bin/mkdir $PATHEVAL
fi
if [ ! -d $PATHOUTPUT ]
then
    /bin/mkdir $PATHOUTPUT
fi
echo "create directories... done!"

########################
# 1. run UIMA Workflow #
########################
# #	- source environment
# . $HEIDELTIME_HOME/metadata/setenv
# #	- run UIMA workflow
# if [[ "$3" == "" ]] ; then
# 	runCPE.sh $PATHWORKFLOW
# fi
######################################
# 2. Run TempEval3 Evaluation Script #
######################################
echo "running TempEval-3 evaluation scorer"
INPUTDIRREF="$(abspath "$PATHCORPUS")"
INPUTDIRTEST="$(abspath "$PATHOUTPUT")"

for file in `ls $INPUTDIRTEST`; do
    IN_FILE="${INPUTDIRTEST}/${file}"
    DATETIME=`grep DATETIME $IN_FILE|head -n 1|sed 's/ *<\/*DATETIME> *//g'`
    echo "Converting $file..."
    OUT_FILE="${IN_FILE/.xml/.tml}"
    /bin/mv $IN_FILE $OUT_FILE
    # /bin/sed -i -r 's/<TimeML>//g' "$OUT_FILE"
    # /bin/sed -i 's/<!DOCTYPE TimeML SYSTEM "TimeML.dtd">/<TimeML xmlns:xsi="http:\/\/www\.w3\.org\/2001\/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http:\/\/timeml\.org\/timeMLdocs\/TimeML_1\.2\.1.xsd">\n<DCT><TIMEX3 value="2018-05-19T12:00:00" tid="t0" type="TIME">2018-05-19T12:00:00<\/TIMEX3><\/DCT>\n<TEXT>/' "$OUT_FILE"
    # /bin/sed -i -r 's/<\/TimeML>/<\/TEXT>\n<\/TimeML>/g' "$OUT_FILE"
    # /bin/sed -i -r 's/ [a-zA-Z]+=""//g' "$OUT_FILE"
    # /bin/sed -i '5d' "$OUT_FILE"

    /bin/sed -i -r 's/<\?xml version="1.0" ?\?>//' "$OUT_FILE"
    /bin/sed -i '1d' "$OUT_FILE"
    /bin/sed -i -r 's/<!?DOCTYPE TimeML SYSTEM "TimeML.dtd">//' "$OUT_FILE"
    /bin/sed -i '1d' "$OUT_FILE"
    /bin/sed -i -r 's/<\/?TimeML>//g' "$OUT_FILE"
    /bin/sed -i '1d' "$OUT_FILE"
    /bin/sed -i 's/<DOC>/<\?xml version="1\.0" \?>\n<TimeML xmlns:xsi="http:\/\/www\.w3\.org\/2001\/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http:\/\/timeml\.org\/timeMLdocs\/TimeML_1\.2\.1.xsd">/' "$OUT_FILE"
    /bin/sed -i -r "s/<DATETIME> ?/<DCT><TIMEX3 value=\"$DATETIME\" tid=\"t0\" type=\"TIME\">/" "$OUT_FILE"
    /bin/sed -i -r 's/ ?<\/DATETIME>/<\/TIMEX3><\/DCT>/' "$OUT_FILE"
    /bin/sed -i -r 's/<\/DOC>/<\/TimeML>/' "$OUT_FILE"
    /bin/sed -i -r 's/<DOCID> /<DOCID>/' "$OUT_FILE"
    /bin/sed -i -r 's/ <\/DOCID>/<\/DOCID>/' "$OUT_FILE"
    /bin/sed -i -r 's/<DOCTYPE.*?<\/DOCTYPE>//' "$OUT_FILE"
    /bin/sed -i -r 's/\|//' "$OUT_FILE"
done

PREVDIR=`pwd`
cd $PATHSCRIPTS/te3-tools
python TE3-evaluation.py $INPUTDIRREF $INPUTDIRTEST 0.5 2>&1 | grep -v "^Normalizing" | grep -vi "token" | grep -vi "^MISSING" > $PATHEVAL/evaluation_results.txt
echo "evaluation results written to $PATHEVAL/evaluation_results.txt"
cd $PREVDIR
#########
#########
# READY #
#########

