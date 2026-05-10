import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const ooc_channel_emoji_sec: FeatureChoiced = {
  name: 'OOC: security emoji',
  category: 'CHAT',
  description: `
  Which icon appears besides your name when you are security in OOC channels.
`,
  component: FeatureDropdownInput,
};

export const ooc_channel_emoji_tot: FeatureChoiced = {
  name: 'OOC: antag emoji',
  category: 'CHAT',
  description: `
  Which icon appears besides your name when you are antag in OOC channels.
`,
  component: FeatureDropdownInput,
};
