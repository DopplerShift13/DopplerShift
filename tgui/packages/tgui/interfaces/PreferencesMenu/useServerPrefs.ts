import { createContext, useContext } from 'react';

import type { ServerData } from './types';

export const ServerPrefs = createContext<ServerData | undefined>({
  jobs: {
    departments: {},
    jobs: {},
  },
  names: {
    types: {},
  },
  quirks: {
    max_positive_quirks: -1,
    quirk_info: {},
    quirk_blacklist: [],
    points_enabled: false,
  },
  personality: {
    personalities: [],
    personality_incompatibilities: {},
  },
  random: {
    randomizable: [],
  },
  loadout: {
    loadout_tabs: [],
  },
  /* DOPPLER EDIT ADDITION START - Powers constant data */
  powers: {
    power_paths: {
      thaumaturge: [],
      enigmatist: [],
      theologist: [],
      psyker: [],
      cultivator: [],
      aberrant: [],
      imbued: [],
      warfighter: [],
      expert: [],
      augmented: [],
      irregular: [],
    },
    total_power_points: 0,
  },
  /* DOPPLER EDIT ADDITION END */
  species: {},
});

export function useServerPrefs() {
  return useContext(ServerPrefs);
}
