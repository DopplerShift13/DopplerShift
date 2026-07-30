import {
  CheckboxInput,
  type FeatureChoiced,
  type FeatureToggle,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const atypical_tastes: FeatureChoiced = {
  name: 'Atypical Tastes',
  component: FeatureDropdownInput,
};

export const tongue_replacement: FeatureToggle = {
  name: 'Replace Tongue',
  description: 'Replaces your tongue with the selected tongue.',
  component: CheckboxInput,
};
