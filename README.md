# WikiWarsUA
### WikiaWars Ukrainian Corpus

## Ukrainian Temporally Tagged Corpus of Historical Narratives

Version: 1.0
Creation Date: April 14, 2019
Release Date: April 14, 2019

Authors:
Natalia Grabar, natalia.grabar@univ-lille.fr
Thierry Hamon, hamon@limsi.fr

## 1. Corpus Description

WikiWarsUA is a corpus of Wikipedia articles describing the most
famous wars in history, including the biggest wars of the 20th
century. It is inspired by the WikiWars corpus [1,2]. Since the
articles related to the Riffian War, the Sudanese Civil War and the
Chaco War are available and contain enough temporal expressions, we
also included them in the corpus. Overall, the corpus contains 25
articles (such as WW1, WW2, Vietnamese war, Russo-Japanese war, or
Punic wars), and 66,479 word occurrences. The articles have been
collected similarly to the building of the original WikiWars corpus
[3].  Each article has been temporally tagged with the respect of
TIMEX3 norm. Overall, on 25 Wikipedia articles, we count 2,719
reference temporal units.

## 2. Repository Structure

The WikiWarsUA package is structured as follows:

WikiWarsUA/README.md
	Current readme file
WikiWarsUA/in/
	Directory containing the 25 documents in SGML format without
	annotations of temporal expressions.
WikiWarsUA/keyinline/
	Directory containing the 25 documents with inline annotations of
	temporal expressions.
WikiWarsUA/scripts
        Directory containing the evaluation script

## 3. Use of the evaluation scripts

The evaluation scripts for WikiWarsUA are based on the Heideltime
evaluation scripts [4].

To run the evaluation scripts, you must follow the following steps
(commands are provided as examples, for clarifying the explanations):

  1. Create a top directory HDLTEVALPATH

```
mkdir HDLTEVALPATH
```

  2. Download the Heideltime evaluation script archive
     (script-2015-06-16.tar.gz or script-2015-06-16.zip) available at
     the end of the web page
     https://dbs.ifi.uni-heidelberg.de/resources/heideltime-corpora-dl/
     and extract them into the HDLTEVALPATH. The scripts are in
     HDLTEVALPATH/scripts .

```cd HDLTEVALPATH
tar xzvf script-2015-06-16.tar.gz
cd ..
```

  3. Create the following directories: UAEVALPATH, UAEVALPATH/corpora,
     UAEVALPATH/corpora/wikiwarsua, UAEVALPATH/uima_output,
     UAEVALPATH/uima_output/wikiwarsua and
     UAEVALPATH/evaluation_results .

```
mkdir UAEVALPATH UAEVALPATH/corpora UAEVALPATH/corpora/wikiwarsua
mkdir UAEVALPATH/uima_output UAEVALPATH/uima_output/wikiwarsua
mkdir UAEVALPATH/evaluation_results
```

  4. Copy the WikiWarsUA/keyinline directory into
     UAEVALPATH/corpora/wikiwarsua

```
cp -a WikiWarsUA/keyinline UAEVALPATH/corpora/wikiwarsua
```

  5. Prepare the WikiWarsUA corpora by running the script
     prepare_corpus.sh with the following arugments: wikiwarsua (name
     of the corpus) UAEVALPATH (path of the corpus)

```
UAVALPATH/scripts/prepare_corpus.sh wikiwarsua UAEVALPATH
```

  6. Copy the files annotated by your sytem in
     UAEVALPATH/uima_output/wikiwarsua .

     Note that the files must have the same name as those in
     UAEVALPATH/corpora/wikiwarsua

```
cp results-hdltua/* UAEVALPATH/uima_output/wikiwarsua
```

   7. Run the evaluation script evaluate_corpus_tempeval3style.sh with
      the following arguments: wikiwarsua (name of the corpus)
      UAEVALPATH (path to the corpus) HDLTEVALPATH (path to the
      heideltime evaluation script)
   
```
UAEVALPATH/scripts/evaluate_corpus_tempeval3style.sh wikiwarsua UAEVALPATH HDLTEVALPATH
```

   8. Evaluation results are in the file
      UAEVALPATH/evaluation_results/wikiwarsua/evaluation_results.txt

```
cat UAEVALPATH/evaluation_results/wikiwarsua/evaluation_results.txt
```



## 4. Acknowledgements

If you use WikiWarsUA, please cite the following paper:

Natalia Grabar and Thierry Hamon (2019). WikiWars-UA: Ukrainian corpus
annotated with temporal expressions. In Proceedings of the Conference
on Computational Linguistics and Intelligent Systems. April 18-19,
2019. Kharkiv, Ukraine

The BibTeX citation is:

```
@InProceedings{Grabar&Hamon2019,
  author = 	 {Natalia Grabar and Thierry Hamon},
  title = 	 {WikiWars-UA: Ukrainian corpus annotated with temporal expressions},
  booktitle = {Proceedings of the Conference on Computational Linguistics and Intelligent Systems},
  year = 	 {2019},
  OPTpages = 	 {},
  month = 	 {April},
  address = 	 {Kharkiv, Ukraine},
  date =      {18-19},
}
```

## 5. License

This work is licensed under a Creative Commons
Attribution-NonCommercial-ShareAlike 3.0 Unported License.
https://en.wikisource.org/wiki/Creative_Commons_Attribution-ShareAlike_3.0_Unported

## 6. References

[1] Mazur, P., Dale, R.: WikiWars: A new corpus for research on
temporal expressions.  In: Int Conf on Empirical Methods in Natural
Language Processing. pp. 913–922 (2010)

[2] http://timexportal.wikidot.com/wikiwars

[3] Readme.txt in
http://timexportal.wikidot.com/local--files/wikiwars/WikiWars_20120218_v104.zip

[4] https://github.com/HeidelTime/heideltime/wiki/Reproducing-Evaluation-Results
