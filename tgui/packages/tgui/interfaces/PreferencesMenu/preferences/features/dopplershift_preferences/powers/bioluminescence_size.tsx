import type { FeatureChoiced } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const bioluminescence_size: FeatureChoiced = {
  name: 'Bioluminescence Size',
  description: 'Chosen glow size.',
  component: FeatureDropdownInput,
};
