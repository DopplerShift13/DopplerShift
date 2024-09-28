//Species
#define isprimitive(A) (is_species(A, /datum/species/genemod/primitive))
//Customization bases
#define isinsectoid(A) (is_species(A, /datum/species/insectoid))
#define issnail(A) (is_species(A, /datum/species/snail))
#define ishemophage(A) (is_species(A, /datum/species/genemod/hemophage))
//Species with green blood
#define hasgreenblood(A) (isinsectoid(A) || HAS_TRAIT(A, TRAIT_GREEN_BLOOD))
