package bi.zum.lab3;

import cz.cvut.fit.zum.api.ga.AbstractEvolution;
import cz.cvut.fit.zum.api.ga.AbstractIndividual;
import cz.cvut.fit.zum.api.ga.AbstractPopulation;
import cz.cvut.fit.zum.data.StateSpace;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * @author Dominik Chodounsky
 */
public class Population extends AbstractPopulation {

    public Population(AbstractEvolution evolution, int size) {
        individuals = new Individual[size];
        for (int i = 0; i < individuals.length; i++) {
            individuals[i] = new Individual(evolution, true);
            individuals[i].computeFitness();
        }
    }

    /**
     * Method to select individuals from population
     *
     * @param count The number of individuals to be selected
     * @return List of selected individuals
     */
    public List<AbstractIndividual> selectIndividuals(int count) {
        
        //tournament
        ArrayList<AbstractIndividual> selected = new ArrayList<AbstractIndividual>();
        int k = 20;
        
        //until we have selected the amout of individuals we want
        while (selected.size() < count) {
            ArrayList<AbstractIndividual> roundParticipants = new ArrayList<AbstractIndividual>();
            Random x = new Random();
            AbstractIndividual participant = individuals[x.nextInt(individuals.length)];
            
            //select a one k-th of individuals for the tournament
            while(roundParticipants.size() < individuals.length/k) {
                roundParticipants.add(participant);
                participant = individuals[x.nextInt(individuals.length)];
            }
            
            AbstractIndividual individual = null;
            double maxFitness = Double.NEGATIVE_INFINITY;
            for(AbstractIndividual i : roundParticipants) {
                if(maxFitness < i.getFitness()) {
                    maxFitness = i.getFitness();
                    individual = i;
                }
            }
            
            selected.add(individual);
        }
        
        return selected;
    }
}
