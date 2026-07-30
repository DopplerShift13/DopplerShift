import { CheckboxInput, FeatureToggle } from '../base';

export const chat_name_coloring: FeatureToggle = {
  name: 'Color character names in chat',
  category: 'CHAT',
  description:
    'If the names of other players should be colored according to their \
    runechat color.',
  component: CheckboxInput,
};
