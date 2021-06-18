#!/bin/bash
ckpt_path=$(dirname $1)
mkdir for_gold
cp -r rushiftEval/*rusemshift for_gold/
python src/tsv_to_json_gold.py --path_to_combine for_gold/
python src/sample_scr.py \ 
--path_to_test rushiftEval/Evaluation_words/ \ 
--path_to_dev rushiftEval/RuSemShift_instances/ \ 
--path_to_sampled pairs/ \ 
--path_to_combine pairs/combine/ \ 
--in_words_dev1 rushiftEval/testset1.tsv \ 
--in_words_dev2 rushiftEval/testset2.tsv \ 
--delete_short_and_long True \ 
--delete_first_and_last_position True \ 
--n_pairs 100
bash mcl-wic/run_wic_model.sh ckpt_path ${@:2}
mkdir sampled_data
mkdir sampled_data/score
mkdir sampled_data/ans
mv model/rusemshift_predictions/*.scores sampled_data/score/
mv model/rusemshift_predictions/* sampled_data/ans/ 
python src/constr.py --type mean
python src/mean_method.py --model_name concat_first
python src/statistics_method.py --model_name concat_first
python src/iso_method.py --model_name concat_first