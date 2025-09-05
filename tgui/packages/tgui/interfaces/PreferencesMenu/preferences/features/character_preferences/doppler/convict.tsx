import {
  Feature,
  FeatureShortTextInput,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const convict_crime: Feature<string> = {
  name: 'Crime',
  component: FeatureShortTextInput,
};
