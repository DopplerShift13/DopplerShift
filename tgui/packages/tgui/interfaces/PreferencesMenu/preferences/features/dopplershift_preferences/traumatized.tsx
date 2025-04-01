import { Feature } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const trauma: Feature<number> = {
  name: 'Chosen Trauma',
  component: FeatureDropdownInput,
};
