import {
  Feature,
  FeatureChoiced,
  FeatureNumberInput,
  FeatureShortTextInput,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const prescription_reagent_name: Feature<string> = {
  name: 'Label of Prescription',
  component: FeatureShortTextInput,
};

export const prescription_application_method: FeatureChoiced = {
  name: 'Method of Application',
  component: FeatureDropdownInput,
};

export const prescription_item_amount: Feature<number> = {
  name: 'Prescribed Amount',
  component: FeatureNumberInput,
};

export const prescription_reagent_amount: Feature<number> = {
  name: 'Units Per',
  component: FeatureNumberInput,
};
