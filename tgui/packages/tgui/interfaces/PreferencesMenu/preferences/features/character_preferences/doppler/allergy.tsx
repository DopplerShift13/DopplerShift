import type { FeatureChoiced } from '../../base';
import { CheckboxInput, type FeatureToggle } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const allergy_selection: FeatureChoiced = {
  name: 'Allergy Choice',
  component: FeatureDropdownInput,
};

export const allergy_super_lethal: FeatureToggle = {
  name: 'Increase Lethaility',
  description:
    "Checking this box makes the alllergy do organ damage and extra \
    toxin damage otherwise, the allergy 'only' gives histamines. \
    (You will still die.)",
  component: CheckboxInput,
};
