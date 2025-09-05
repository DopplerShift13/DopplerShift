import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const limping_side: FeatureChoiced = {
  name: 'Affected Side',
  component: FeatureDropdownInput,
};

export const limping_severity: FeatureChoiced = {
  name: 'Severity',
  component: FeatureDropdownInput,
};