import {
  type Feature,
  type FeatureChoiced,
  FeatureShortTextInput,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const false_power_entry: Feature<string> = {
  name: 'False Power Entry',
  description: 'Custom security record text (max 100 chars).',
  component: FeatureShortTextInput,
};

export const false_power_severity: FeatureChoiced = {
  name: 'False Power Severity',
  description: 'Threat severity shown in security records.',
  component: FeatureDropdownInput,
};
