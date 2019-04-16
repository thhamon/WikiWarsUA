#!/bin/bash

# inspired from the prepare_corpus.sh script available at
# https://github.com/HeidelTime/heideltime/wiki/Reproducing-Evaluation-Results

if [ $# -lt 2 ]
then
    echo "Error in $0 - Invalid Argument Count"
    echo "Syntax: $0 <CORPUS> <EVALPATH>"
    echo "with CORPUS being one of the following:"
    echo "- wikiwarsua"
    echo ""
    exit
fi

if [ "$1" = "wikiwarsua" ]
then
    echo "Corpus to prepare: $1"
else
    echo "Corpus name not correct: Choose one of the following corpora:"
    echo "- wikiwarsua"
    exit
fi


##############################################
# adapt EVALPATH to your heideltime_eval_dir #
##############################################
CORPUS=$1
EVALPATH=$2
echo "preparing $CORPUS corpus..."
PATHCORPUS=unknown

#####################################
# WIKIWARSUA ########################
#####################################
if [ "$CORPUS" = "wikiwarsua" ]
then
    PATHCORPUS="$EVALPATH/corpora/WikiWarsUA/"
    # translate ACE Tern format into TimeML for TE3 evaluation
    mkdir $PATHCORPUS/timeml/
    IN_FOLDER="$PATHCORPUS/keyinline/"
    OUT_FOLDER="$PATHCORPUS/timeml/"
    for file in `ls $IN_FOLDER`; do
        IN_FILE="${IN_FOLDER}/${file}"
        echo "Converting $file..."
        OUT_FILE="${OUT_FOLDER}/$(basename ${IN_FILE/.key.xml/.tml})"
	ID_FILE="$(basename ${IN_FILE/.key.xml/})"
        /bin/cp $IN_FILE $OUT_FILE
	# /bin/sed -i -r 's/<TimeML>//g' "$OUT_FILE"
        # /bin/sed -i 's/<!DOCTYPE TimeML SYSTEM "TimeML.dtd">/<TimeML xmlns:xsi="http:\/\/www\.w3\.org\/2001\/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http:\/\/timeml\.org\/timeMLdocs\/TimeML_1\.2\.1.xsd">\n<DCT><TIMEX3 value="2018-05-20T10:35:47" tid="t0" type="TIME">2018-05-20T10:35:47<\/TIMEX3><\/DCT>\n<TEXT>/' "$OUT_FILE"
	# /bin/sed -i -r 's/<\/TimeML>/<\/TEXT>\n<\/TimeML>/g' "$OUT_FILE"
	# /bin/sed -i -r 's/ [a-zA-Z]+=""//g' "$OUT_FILE"
        # /bin/sed -i -r 's/<DATETIME> ?/<DCT>/' "$OUT_FILE"
        # /bin/sed -i -r 's/ ?<\/DATETIME>/<\/DCT>/' "$OUT_FILE"
        # /bin/sed -i -r 's/<\/DOC>/<\/TimeML>/' "$OUT_FILE"
        # /bin/sed -i -r 's/<DOCID> /<DOCID>/' "$OUT_FILE"
        # /bin/sed -i -r 's/ <\/DOCID>/<\/DOCID>/' "$OUT_FILE"
        # /bin/sed -i -r 's/<DOCTYPE.*?<\/DOCTYPE>//' "$OUT_FILE"
        # /bin/sed -i -r 's/\|//' "$OUT_FILE"
	/bin/sed -i -r 's/<\/?TimeML>//g' "$OUT_FILE"
        /bin/sed -i 's/<DOC>/<\?xml version="1\.0" \?>\n<TimeML xmlns:xsi="http:\/\/www\.w3\.org\/2001\/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http:\/\/timeml\.org\/timeMLdocs\/TimeML_1\.2\.1.xsd">/' "$OUT_FILE"
        /bin/sed -i -r 's/<DATETIME> ?/<DCT>/' "$OUT_FILE"
        /bin/sed -i -r 's/ ?<\/DATETIME>/<\/DCT>/' "$OUT_FILE"
        /bin/sed -i -r 's/<\/DOC>/<\/TimeML>/' "$OUT_FILE"
        /bin/sed -i -r 's/<DOCID> /<DOCID>/' "$OUT_FILE"
        /bin/sed -i -r 's/ <\/DOCID>/<\/DOCID>/' "$OUT_FILE"
        /bin/sed -i -r 's/<DOCTYPE.*?<\/DOCTYPE>//' "$OUT_FILE"
        /bin/sed -i -r 's/\|//' "$OUT_FILE"
    done
fi

echo "preparing $CORPUS corpus... done!"
