/*
  Passes powers path data to the TGUI side, as well as offering a few fallback options to prevent everything from breaking.
*/

import { useEffect, useState } from 'react';
import type {
  PowerArchetypeData,
  PowerPathData,
  PowerPathId,
  ServerData,
} from './types';
import { useServerPrefs } from './useServerPrefs';

type PowerCatalogData = ServerData['powers'];

export const fallbackPowerPathId: PowerPathId = 'thaumaturge';

/// Fallback path data in case of errors.
const fallbackPowerPathData: PowerPathData = {
  displayName: 'Fallback Path',
  archetypeId: 'fallback',
  isAvailable: false,
  mechanicsText:
    'The power path bridge could not resolve DM-provided path data for this selection.',
  overviewText:
    'Please message the developers and include the steps you took to produce this effect.',
  themeColor: '#ffffff',
};

/// Gets the ID of the fallback power in case of errors
export function getFallbackPowerPathId(
  powerCatalogData?: PowerCatalogData,
): PowerPathId {
  return powerCatalogData?.fallback_power_path_id || fallbackPowerPathId;
}

/// Gets and returns a single power path's DM-provided constant data from the powers prefs payload.
export function getPowerPathData(
  powerCatalogData: PowerCatalogData | undefined,
  pathId: PowerPathId,
): PowerPathData {
  return powerCatalogData?.power_path_data[pathId] || fallbackPowerPathData;
}

/// Returns the serverPref's powers property from serverprefs, which lists all powers, archetypes, etc..
export function getPowerCatalogData() {
  return useServerPrefs()?.powers;
}

/// Gets and returns all powers archetypes.
export function getPowerArchetypes(
  powerCatalogData: PowerCatalogData | undefined,
): PowerArchetypeData[] {
  return powerCatalogData?.power_path_archetypes || [];
}

/// Takes a given path ID, validates it, and then returns the requested path ID if valid or the fallback path's ID (see above) if invalid.
export function useValidatedPowerPathId(
  requestedPathId: PowerPathId,
): PowerPathId {
  const powerCatalogData = getPowerCatalogData();
  const resolvedFallbackPowerPathId = getFallbackPowerPathId(powerCatalogData);

  // If the fallback path's ID was given
  if (requestedPathId === fallbackPowerPathId) {
    return resolvedFallbackPowerPathId;
  }

  // If a path's ID was given that matches an existing path.
  if (powerCatalogData?.power_path_data[requestedPathId]) {
    return requestedPathId;
  }

  // If you did not give a valid path ID.
  return resolvedFallbackPowerPathId;
}

/// Returns the power path that is currently selected in the UI.
export function useSelectedPowerPath() {
  const [requestedPowerPathId, setRequestedPowerPathId] =
    useState<PowerPathId>(fallbackPowerPathId);
  const resolvedPowerPathId = useValidatedPowerPathId(requestedPowerPathId);

  useEffect(() => {
    if (requestedPowerPathId === resolvedPowerPathId) {
      return;
    }

    setRequestedPowerPathId(resolvedPowerPathId);
  }, [requestedPowerPathId, resolvedPowerPathId]);

  return {
    selectedPowerPathId: resolvedPowerPathId,
    setSelectedPowerPathId: setRequestedPowerPathId,
  };
}
