Overview
----

This project offers a way to import phoneme-labeled utterances from
[festival](http://festvox.org/) voices into Praat. The current implementation
downloads and builds the 13 Indic voices, dumps phoneme segment information for
the first hundred utterances of each (some voices including English utterances
as well), and then generates Praat TextGrids for each utterance according to
the segment durations labeled by the festival voice.

Project Structure
----

| Files                 |                   |
| --------------------- | ----------------- |
| `data/              ` | working files, intermediate outputs |
| `data/cmu_indic_*/  ` | individual festival voice folders |
| `data/segments/     ` | segment duration output |
| `data/segments/all/ ` | primary working space over all utterances |
| `data/segments/all/vowel_segments/` | output of isolated vowel instances |
| `log/*              ` | logging output, final formant data |
| `praat/*            ` | Praat scripts used for Praat-dependent operations |
| `do_indic.sh        ` | download and build Indic voices, create data directory structure, dump segment information to dur files |
| `do_text_grid_segments.py` | add phoneme segments to TextGrid's according to segment durations in corresponding dur file |
| `do_vowel_inv.py    ` | generate list of all vowels appearing in segment duration output |
| `README.md          ` | this file :) |

Running
----

The sequence of scripts to execute is as follows.

First, download and build the Indic voices, then dump all phoneme segment
information for the first 100 utterances of each voice to log files, using the
`do_indic.sh` script.

```
$ bash do_indic.sh
```

Next from Praat, run the `text-grid-maker.praat` script to create blank
TextGrids for every wav file.

Finally use the `do_text_grid_segments.py` script to add all segment duration
information to the TextGrids (this will manually edit the TextGrid files to
combine the info from the TextGrid header with the segment durations in order
to create intervals and labels we can load into Praat).

```
$ python do_text_grid_segments.py
```

From here you can execute whatever analysis you need on the now-labeled
utterances.

To create a formant dataset of all vowels' formants, adjust the
`segmenter.praat` script with the target phonemes (in the `vowellabels` array).
To see a list of all vowels observed in the segment duration analysis output by
festival, run the `do_vowel_inv.py` script.

```
$ do_vowel_inv.py
```

The `segmenter.praat` script will now cut out the instance of every single
vowel and save it as its own sound file (in `data/segments/all/vowel_segments`).

Execution of the `Get_Formants.praat` script will now create a
`log/vowel_formants.log` file with F1, F2, and F3 measurements over 10 intervals
for every single vowel instance.

----

Credit to Katherine Crosswhite and Christian DiCanio for Praat scripts used in
making this Indic vowel formant dataset.
