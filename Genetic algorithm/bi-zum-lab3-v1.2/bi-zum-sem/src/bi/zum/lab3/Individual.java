package bi.zum.lab3;

import cz.cvut.fit.zum.api.Node;
import cz.cvut.fit.zum.api.ga.AbstractEvolution;
import cz.cvut.fit.zum.api.ga.AbstractIndividual;
import cz.cvut.fit.zum.data.Edge;
import cz.cvut.fit.zum.data.StateSpace;
import cz.cvut.fit.zum.util.Pair;
import java.util.Random;


/**
 * @author Dominik Chodounsky
 */
public class Individual extends AbstractIndividual {

    private double fitness = Double.NaN;
    private AbstractEvolution evolution;
    private boolean[] genotype;
    

    /**
     * Creates a new individual
     * 
     * @param evolution The evolution object
     * @param randomInit <code>true</code> if the individual should be
     * initialized randomly (we do wish to initialize if we copy the individual)
     */
    public Individual(AbstractEvolution evolution, boolean randomInit) {
        this.evolution = evolution;
        this.genotype = new boolean[StateSpace.nodesCount()];
        
        if(randomInit) {
            for(int i = 0; i < StateSpace.nodesCount(); ++i) {
                Random r = new Random();
                this.genotype[i] = r.nextBoolean();
            }
        }
    }

    @Override
    public boolean isNodeSelected(int j) {
        return genotype[j];
    }

    /**
     * Evaluate the value of the fitness function for the individual. After
     * the fitness is computed, the <code>getFitness</code> may be called
     * repeatedly, saving computation time.
     */
    @Override
    public void computeFitness() {
        this.repair();
        this.fitness = 0;
              
        for(int i = 0; i < StateSpace.nodesCount(); ++i) {
            //not selected
            if(!genotype[i]) this.fitness += 3;
            
            Node node = StateSpace.getNode(i);
            
            //is leaf
            if(node.getEdges().size() == 1 && genotype[i]) {
                if(genotype[i]) this.fitness -= 5;
                else this.fitness += 1;
            }
        }
    }
    

    /**
     * Only return the computed fitness value
     *
     * @return value of fitness function
     */
    @Override
    public double getFitness() {
        return this.fitness;
    }

    /**
     * Does random changes in the individual's genotype, taking mutation
     * probability into account.
     * 
     * @param mutationRate Probability of a bit being inverted, i.e. a node
     * being added to/removed from the vertex cover.
     */
    @Override
    public void mutate(double mutationRate) {        
        for(int i = 0; i < StateSpace.nodesCount(); ++i) {
            Random rand = new Random();
            boolean mutate = rand.nextDouble() < mutationRate;
            
            if(mutate) {
                genotype[i] = !genotype[i];
            }
        }
    }
    
    /**
     * Crosses the current individual over with other individual given as a
     * parameter, yielding a pair of offsprings.
     * 
     * @param other The other individual to be crossed over with
     * @return A couple of offspring individuals
     */
    @Override
    public Pair crossover(AbstractIndividual other) {

        Pair<Individual,Individual> result = new Pair();
        Individual otherI = (Individual)other;
        
        //children
        Individual firstChild = new Individual(evolution, false);
        Individual secondChild = new Individual(evolution, false);
        
        int oneThird = StateSpace.nodesCount() / 3;
        
        //perform 2-point crossover with sections split into thirds
        for(int i = 0; i < oneThird; ++i) {
            firstChild.genotype[i] = this.genotype[i];
            secondChild.genotype[i] = otherI.genotype[i];
        }
        for(int i = oneThird; i < StateSpace.nodesCount() - oneThird; ++i) {
            firstChild.genotype[i] = otherI.genotype[i];
            secondChild.genotype[i] = this.genotype[i];
        }
        for(int i = StateSpace.nodesCount() - oneThird; i < StateSpace.nodesCount(); ++i) {
            firstChild.genotype[i] = this.genotype[i];
            secondChild.genotype[i] = otherI.genotype[i];
        }
        
        result.a = firstChild;
        result.b = secondChild;
        return result;
    }

    
    /**
     * When you are changing an individual (eg. at crossover) you probably don't
     * want to affect the old one (you don't want to destruct it). So you have
     * to implement "deep copy" of this object.
     *
     * @return identical individual
     */
    @Override
    public Individual deepCopy() {
        Individual newOne = new Individual(evolution, false);
        
        for(int i = 0; i < StateSpace.nodesCount(); ++i) {
            newOne.genotype[i] = this.genotype[i];
        }

        // TODO: at least you should copy your representation of search-space state

        // for primitive types int, double, ...
        // newOne.val = this.val;

        // for objects (String, ...)
        // for your own objects you have to implement clone (override original inherited from Objcet)
        // newOne.infoObj = thi.infoObj.clone();

        // for arrays and collections (ArrayList, int[], Node[]...)
        /*
         // new array of the same length
         newOne.pole = new MyObjects[this.pole.length];		
         // clone all items
         for (int i = 0; i < this.pole.length; i++) {
         newOne.pole[i] = this.pole[i].clone(); // object
         // in case of array of primitive types - direct assign
         //newOne.pole[i] = this.pole[i]; 
         }
         // for collections -> make new instance and clone in for/foreach cycle all members from old to new
         */

        newOne.fitness = this.fitness;
        return newOne;
    }

    /**
     * Return a string representation of the individual.
     *
     * @return The string representing this object.
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        
        for(int i = 0; i < StateSpace.nodesCount(); ++i) {
            if(genotype[i]&& i != StateSpace.nodesCount() - 1) {
                sb.append(i + ", ");
            }
            else if(genotype[i]&& i == StateSpace.nodesCount() - 1) {
                sb.append(i);
            }
        }        
        
        sb.append(super.toString());

        return sb.toString();
    }
    
    /**
    * Repairs the genotype to make it valid, i.e. ensures all the edges
    * are in the vertex cover.
    */
    private void repair() {

        /* We iterate over all the edges */
        for(Edge e : StateSpace.getEdges()) {
           int from = e.getFromId();
           int to = e.getToId();
           
           if(!genotype[from] && !genotype[to]) {
               Random r = new Random();
               int x = r.nextInt()%2;
               
               switch (Math.abs(x)) {
                case 0:
                    genotype[from] = true;
                    break;
                case 1:
                    genotype[to] = true;
                    break;
                default:
                    break;
                }
           }
        }
    }
}
