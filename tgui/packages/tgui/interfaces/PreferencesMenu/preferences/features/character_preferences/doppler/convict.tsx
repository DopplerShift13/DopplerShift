import {
  Feature,
  FeatureShortTextInput,
} from '../../base';

export const convict_crime_name: Feature<string> = {
  name: 'Crime Committed',
  component: FeatureShortTextInput,
};
