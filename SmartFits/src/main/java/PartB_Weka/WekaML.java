package PartB_Weka;

import weka.classifiers.Classifier;
import weka.classifiers.bayes.NaiveBayes;
import weka.classifiers.Evaluation;
import weka.core.Instance;
import weka.core.DenseInstance;
import weka.core.Instances;
import weka.core.converters.CSVLoader;
import weka.core.SerializationHelper;

import java.io.File;
import java.util.Random;
import java.util.Scanner;

public class WekaML {

    public static void main(String[] args) {
        try {
            // possible dataset paths
            String datasetPath = "workout_dataset.csv";
            File datasetFile = new File(datasetPath);

            // fallback (when running from Maven/NetBeans root)
            if (!datasetFile.exists()) {
                datasetFile = new File("src/main/java/PartB_Weka/workout_dataset.csv");
            }

            // check if file exists
            if (!datasetFile.exists()) {
                System.err.println("⚠️ Dataset not found. Please make sure 'workout_dataset.csv' exists in PartB_Weka folder.");
                return;
            }

            System.out.println("📁 Loading dataset from: " + datasetFile.getAbsolutePath());

            // load CSV into Weka
            CSVLoader loader = new CSVLoader();
            loader.setSource(datasetFile);
            Instances data = loader.getDataSet();
            data.setClassIndex(0); // first column = activity_type

            // random shuffle + split 70/30
            data.randomize(new Random(42));
            int trainSize = (int) Math.round(data.numInstances() * 0.7);
            int testSize = data.numInstances() - trainSize;
            Instances train = new Instances(data, 0, trainSize);
            Instances test = new Instances(data, trainSize, testSize);

            // train NaiveBayes model
            Classifier nb = new NaiveBayes();
            nb.buildClassifier(train);

            // evaluate performance
            Evaluation eval = new Evaluation(train);
            eval.evaluateModel(nb, test);

            System.out.println("\n=== Model Info (NaiveBayes) ===");
            System.out.println("Train instances: " + train.numInstances());
            System.out.println("Test instances : " + test.numInstances());
            System.out.println("Accuracy        : " + String.format("%.2f%%", eval.pctCorrect()));
            System.out.println("\nConfusion Matrix:\n" + eval.toMatrixString());
            System.out.println("\nClass Details:\n" + eval.toClassDetailsString());

            // save trained model beside dataset
            String modelPath = datasetFile.getParent() + File.separator + "activity_model_nb.model";
            SerializationHelper.write(modelPath, nb);
            System.out.println("✅ Model saved to: " + modelPath);

            // interactive prediction
            Scanner sc = new Scanner(System.in);
            System.out.println("\n--- Try a quick prediction ---");
            System.out.print("Duration (min): ");
            double dur = sc.nextDouble();
            System.out.print("Distance (km): ");
            double dist = sc.nextDouble();
            System.out.print("Calories: ");
            double cal = sc.nextDouble();

            String pred = predict(nb, data, dur, dist, cal);
            System.out.println("🏋️ Predicted Activity → " + pred);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // helper for single prediction
    private static String predict(Classifier model, Instances template, double dur, double dist, double cal) {
        try {
            Instance inst = new DenseInstance(template.numAttributes());
            inst.setDataset(template);
            inst.setMissing(0); // unknown class
            inst.setValue(template.attribute("duration_min"), dur);
            inst.setValue(template.attribute("distance_km"), dist);
            inst.setValue(template.attribute("calories"), cal);

            double idx = model.classifyInstance(inst);
            return template.classAttribute().value((int) idx);
        } catch (Exception ex) {
            ex.printStackTrace();
            return "Error";
        }
    }
}
