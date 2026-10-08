import {
  FeatureIconnedDropdownInput,
  type FeatureWithIcons,
} from '../../dropdowns';

export const summonable_language: FeatureWithIcons<string> = {
  name: 'Summonable Language',
  description: 'Restricts which spoken language can trigger your summon.',
  component: FeatureIconnedDropdownInput,
};
