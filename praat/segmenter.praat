## This script sections a file into individual vowels, vowels having been marked in some tier using one of the labels listed in "vowellabels".
##  Each vowel is saved as an individual Praat Sound file with the name of the original file plus a number indicating which vowel is being saved.
## 25 milliseconds is included to either side of the vowel, to make sure that a formant object includes the entire vowel (25 ms. frames).

## Specify the set of phoneme labels marking the vowels:
## TODO: set the following array to include all vowels generated by
## do_vowel_inv.py, and update loop guard below for correct vowellabels length
vowellabels$ [1]  = "i"
vowellabels$ [2]  = "aI"
vowellabels$ [3]  = "A"
vowellabels$ [4]  = "e"
vowellabels$ [5]  = "E"
vowellabels$ [6]  = "i:"
vowellabels$ [7]  = "u"
vowellabels$ [8]  = "o"
vowellabels$ [9] = "A:"
vowellabels$ [10] = "u:"
vowellabels$ [11] = "ay"
vowellabels$ [12] = "aU"
vowellabels$ [13] = "ow"
vowellabels$ [14] = "o:"
vowellabels$ [15] = "e:"
vowellabels$ [16] = "uy"
vowellabels$ [17]  = "9r"
vowellabels$ [18] = "9r="
vowellabels$ [19] = "inas"
vowellabels$ [20] = "A:nas"
vowellabels$ [21] = "o:nas"
vowellabels$ [22] = "unas"
vowellabels$ [23] = "aInas"
vowellabels$ [24] = "i:nas"
vowellabels$ [25] = "enas"
vowellabels$ [26] = "onas"
vowellabels$ [27] = "u:nas"
vowellabels$ [28] = "ownas"

##  Specify the tier where the vowels are labeled here:
tier_number = 1

form Extract vowel segments
   ##  Specify the directory where your sound files and accompanying textgrids are located:
   sentence Directory "CHANGEME/data/segments/all/"
   ##  Specify the directory where you want the segmented vowel sound files to be stored:
   sentence Outdir "CHANGEME/data/segments/all/vowel_segments/"
   ##  Specify what file extension your sound files end in (.wav, .aiff...)
   sentence Extension ".wav"
endform

clearinfo
Create Strings as file list... list 'directory$'*'extension$'
number_of_files = Get number of strings

for a from 1 to number_of_files
     for b from 1 to 28
          ##  Specify the label you've used to mark your vowels here:
          label$ = vowellabels$ [b]

          select Strings list
          current_sound$ = Get string... 'a'
          Read from file... 'directory$''current_sound$'
          current_sound$ = selected$("Sound")
          Read from file... 'directory$''current_sound$'.TextGrid

          number_vowels = Count labels... 1 'label$'
          Extract tier... 'tier_number'
          current_tier = selected ("IntervalTier")
          Get starting points... 'label$'
          starting_points = selected ("PointProcess")
          select 'current_tier'
          Get end points... 'label$'
          end_points = selected ("PointProcess")
          for i from 1 to number_vowels
               select 'starting_points'
               start'i' = Get time from index... 'i'
               select 'end_points'
               end'i' = Get time from index... 'i'
          endfor
          select Sound 'current_sound$'
          Edit
          for j from 1 to number_vowels
               editor Sound 'current_sound$'
               start = start'j'
               end = end'j'
               Select... 'start' 'end'
               Extract selection
               endeditor
               Write to binary file... 'outdir$''current_sound$'-'label$'-'j'.Sound
          endfor
          select all
          minus Strings list
          Remove
     endfor
endfor
select all
Remove
print All files have been segmented!  Have a nice day!

## written by Katherine Crosswhite
## crosswhi@ling.rochester.edu

## modification for many target labels by Clifford Ressel
