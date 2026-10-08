import {
  type Feature,
  type FeatureChoiced,
  FeatureColorInput,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const raking_claws_fur_color: Feature<string> = {
  name: 'Fur Color',
  description: 'Color of the fur covering your transformed arms.',
  component: FeatureColorInput,
};

export const raking_claws_claw_color: Feature<string> = {
  name: 'Claw Color',
  description: 'Color of the claws extending from your transformed arms.',
  component: FeatureColorInput,
};

export const raking_claws_arm_style: FeatureChoiced = {
  name: 'Claw Style',
  description: 'Appearance of your transformed arms and claws.',
  component: FeatureDropdownInput,
};
