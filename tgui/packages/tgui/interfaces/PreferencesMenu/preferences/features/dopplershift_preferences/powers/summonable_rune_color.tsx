import { FeatureColorInput, type Feature } from '../../base';

export const summonable_rune_color: Feature<string> = {
  name: 'Summonable Color',
  description: 'Rune and spotlight color.',
  component: FeatureColorInput,
};
