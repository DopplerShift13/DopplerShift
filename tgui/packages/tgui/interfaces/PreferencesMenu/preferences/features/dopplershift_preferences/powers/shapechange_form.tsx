import type { FeatureChoiced } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const shapechange_form: FeatureChoiced = {
  name: 'Shapechange',
  description: 'Chosen animal form.',
  component: FeatureDropdownInput,
};
