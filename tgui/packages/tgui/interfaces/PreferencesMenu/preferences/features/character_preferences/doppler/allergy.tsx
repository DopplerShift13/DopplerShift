import type { FeatureChoiced } from '../../base';
import { CheckboxInput, type FeatureToggle } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const allergy_selection: FeatureChoiced = {
  name: 'Allergy Choice',
  component: FeatureDropdownInput,
};

export const allergy_super_lethal: FeatureToggle = {
  name: 'Increase Lethality',
  description:
    "Checking this box makes the alllergy have a chance to do organ damage \
    alongside extra toxin damage and histamines (You will die very fast.)\
    otherwise, the allergy 'only' gives histamines. \
    (You will still die.)",
  component: CheckboxInput,
};
