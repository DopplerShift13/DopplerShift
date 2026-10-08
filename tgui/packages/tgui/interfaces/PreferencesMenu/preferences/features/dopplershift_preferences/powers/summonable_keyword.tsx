import { Feature, FeatureShortTextInput } from '../../base';

export const summonable_keyword: Feature<string> = {
  name: 'Summonable Keyword',
  description: 'Single word used to summon you.',
  component: FeatureShortTextInput,
};
