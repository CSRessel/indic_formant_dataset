LANG=C; export LANG

if [ ! "$ESTDIR" ]
then
  echo "environment variable ESTDIR is unset"
  echo "set it to your local speech tools directory e.g."
  echo '   bash$ export ESTDIR=/home/awb/projects/speech_tools/'
  echo or
  echo '   csh% setenv ESTDIR /home/awb/projects/speech_tools/'
  echo 'Ensure you have set ESTDIR, FESTVOXDIR, SPTK and FLITEDIR'
  echo 'See festvox.org/do_install for installing the FestVox Tools suite'
  exit 1
fi
if [ ! "$ESTDIR" ]
then
  echo "could not find festival installation"
  echo "at $FESTVOX/../festival"
  exit 1
fi

INDIC_DB_DIR=http://tts.speech.cs.cmu.edu/awb/h2r_indic

mkdir data
cd data
mkdir -p segments/all/vowel_segments
echo "segment_duration name p.name n.name" > featlist

for ld in ben_rm guj_{ad,dp,kt} kan_plv hin_ab mar_{aup,slp} pan_amp tam_sdr tel_{kpn,sk,ss}; do
  echo "---------------- processing cmu_indic_${ld} ----------------"

  # Set up voice
  mkdir cmu_indic_${ld}
  cd cmu_indic_${ld}
  lang=`echo ${ld} | cut -d_ -f1`
  dial=`echo ${ld} | cut -d_ -f2`
  $FESTVOXDIR/src/clustergen/setup_cg_indic cmu indic ${lang} ${dial}

  # Get waveforms and transcription
  ( cd recording &&
    wget ${INDIC_DB_DIR}/cmu_indic_${ld}.tar.bz2 &&
    tar jxvf cmu_indic_${ld}.tar.bz2
  )
  cp -pr recording/cmu_indic_${ld}/* .

  # Build utterances
  ./bin/do_build build_prompts
  ./bin/do_build label
  ./bin/do_build build_utts

  # Dump segment durations
  mkdir ../segments/${ld}
  for i in `seq -w 1 100`; do
    $FESTVOXDIR/../festival/examples/dumpfeats -feats ../featlist \
      -relation Segment -output ../segments/${ld}/%s.dur \
      festival/utts/*$i.utt
	  cp wav/*$i.wav ../segments/${ld}/
  done
  for f in ../segments/${ld}/*.{dur,wav}; do
    cp $f ../segments/all/${ld}_`basename ${f}`
  done

  cd ..
done

rm -f data/segments/all/*\**
