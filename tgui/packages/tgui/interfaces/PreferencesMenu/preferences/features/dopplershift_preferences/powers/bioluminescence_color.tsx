import { FeatureColorInput, type Feature } from '../../base';

export const bioluminescence_color: Feature<string> = {
  name: 'Bioluminescence Color',
  description: 'Chosen glow color.',
  component: FeatureColorInput,
};
