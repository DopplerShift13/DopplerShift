import { Feature, FeatureShortTextInput, type FeatureChoiced } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const premonition_keyword: Feature<string> = {
  name: 'Premonition Keyword',
  description: 'Phrase that triggers your premonition.',
  component: FeatureShortTextInput,
};

export const premonition_emote: FeatureChoiced = {
  name: 'Premonition Emote',
  description: 'Emote triggered by your premonition.',
  component: FeatureDropdownInput,
};
