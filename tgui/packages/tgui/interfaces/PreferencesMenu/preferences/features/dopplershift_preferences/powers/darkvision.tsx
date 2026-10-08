import { type Feature, FeatureNumberInput } from '../../base';

export const darkvision_cutoff_red: Feature<number> = {
  name: 'Darkvision Red Cutoff',
  description:
    'Red channel cutoff. Higher means that color is more intense in dark areas.',
  component: FeatureNumberInput,
};

export const darkvision_cutoff_green: Feature<number> = {
  name: 'Darkvision Green Cutoff',
  description:
    'Green channel cutoff. Higher means that color is more intense in dark areas',
  component: FeatureNumberInput,
};

export const darkvision_cutoff_blue: Feature<number> = {
  name: 'Darkvision Blue Cutoff',
  description:
    'Blue channel cutoff. Higher means that color is more intense in dark areas',
  component: FeatureNumberInput,
};
