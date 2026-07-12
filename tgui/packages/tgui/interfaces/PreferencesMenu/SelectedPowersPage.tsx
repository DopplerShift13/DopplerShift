/*
Showcases all your currently selected powers on a compact page, so you have a bigger overview of your character's capabilities.
*/
import { Box, Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { mergePowerPathData } from './PowerData';
import {
  getPowerPathData,
  getPowerArchetypes,
  getPowerCatalogData,
} from './PowerPathBridge';
import {
  buildPowerTreeNodes,
  flattenPowerTreeNodes,
  hexToRgba,
  NestedPowerTree,
} from './PowerPathPage';
import type { PowerPathId, PreferencesMenuData } from './types';

type SelectedPowersPageProps = {
  handleClosePage: () => void;
};

type SelectedPathSection = {
  pathId: PowerPathId;
  selectedCount: number;
};

export function SelectedPowersPage(props: SelectedPowersPageProps) {
  const { act, data } = useBackend<PreferencesMenuData>();
  const powerCatalogData = getPowerCatalogData();
  const powerArchetypes = getPowerArchetypes(powerCatalogData);
  const { handleClosePage } = props;

  if (!powerCatalogData) {
    return null;
  }

  const mergedPowerPaths = mergePowerPathData(
    powerCatalogData.power_paths,
    data.power_state_paths,
  );
  const orderedPathIds = powerArchetypes.flatMap(
    (archetypeData) => archetypeData.pathIds,
  );
  const manuallyRenderedFeatures =
    data.character_preferences.manually_rendered_features;
  const selectedPathSections: SelectedPathSection[] = orderedPathIds
    .map((pathId) => ({
      pathId,
      selectedCount: (mergedPowerPaths[pathId] || []).filter(
        (power) => power.has_power,
      ).length,
    }))
    .filter((pathSection) => pathSection.selectedCount > 0);
  const totalSelectedPowers = selectedPathSections.reduce(
    (total, pathSection) => total + pathSection.selectedCount,
    0,
  );

  return (
    <Box
      style={{
        backgroundColor: 'rgba(20, 22, 28, 0.98)',
        minHeight: '100%',
        padding: '0.5rem',
      }}
    >
      <Stack align="stretch" fill g={2}>
        <Stack.Item minWidth="280px" shrink={0}>
          <Stack vertical>
            <Stack.Item>
              <Section
                title="Your Powers"
                style={{
                  border: '1px solid rgba(255, 255, 255, 0.14)',
                  boxShadow: '0 0 20px rgba(0, 0, 0, 0.35)',
                }}
              >
                <Box
                  style={{
                    fontSize: '1.4rem',
                    fontWeight: 600,
                    textAlign: 'center',
                  }}
                >
                  {data.power_points}/{powerCatalogData.total_power_points}{' '}
                  Points
                </Box>
                <Box
                  color="label"
                  mt={0.5}
                  style={{
                    textAlign: 'center',
                    textTransform: 'uppercase',
                  }}
                >
                  {`${totalSelectedPowers} selected powers`}
                </Box>
                <Button
                  color="default"
                  fluid
                  icon="arrow-left"
                  mt={1.5}
                  onClick={handleClosePage}
                >
                  Return To Powers
                </Button>
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section
                fill
                scrollable
                title="Selected Powers"
                style={{
                  minHeight: '420px',
                }}
              >
                {selectedPathSections.length ? (
                  <Stack vertical g={1}>
                    {selectedPathSections.map((pathSection) => {
                      const pathConfig = getPowerPathData(
                        powerCatalogData,
                        pathSection.pathId,
                      );
                      const selectedPathPowers = mergedPowerPaths[
                        pathSection.pathId
                      ]?.filter((power) => power.has_power) || [];
                      const { anyRootNodes, rootNodes } =
                        buildPowerTreeNodes(selectedPathPowers);
                      const orderedSelectedPowers = flattenPowerTreeNodes([
                        ...rootNodes,
                        ...anyRootNodes,
                      ]);

                      return (
                        <Stack.Item key={pathSection.pathId}>
                          <Section
                            title={pathConfig.displayName}
                            style={{
                              border: `1px solid ${pathConfig.themeColor}`,
                              boxShadow: `0 0 12px ${hexToRgba(
                                pathConfig.themeColor,
                                0.18,
                              )}`,
                            }}
                          >
                            <Stack vertical g={0.6}>
                              {orderedSelectedPowers.map((power) => (
                                <Stack.Item key={power.name}>
                                  <Stack align="center">
                                    <Stack.Item grow>
                                      <Box style={{ color: 'white' }}>
                                        {power.name}
                                      </Box>
                                    </Stack.Item>
                                    <Stack.Item>
                                      <Button
                                        color="bad"
                                        icon="xmark"
                                        onClick={() =>
                                          act('remove_power', {
                                            power_name: power.name,
                                          })
                                        }
                                      />
                                    </Stack.Item>
                                  </Stack>
                                </Stack.Item>
                              ))}
                            </Stack>
                          </Section>
                        </Stack.Item>
                      );
                    })}
                  </Stack>
                ) : (
                  <Box color="label">You have not selected any powers.</Box>
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow>
          <Stack vertical g={2}>
            {selectedPathSections.length ? (
              selectedPathSections.map((pathSection) => {
                const pathConfig = getPowerPathData(
                  powerCatalogData,
                  pathSection.pathId,
                );
                const selectedPowers = mergedPowerPaths[
                  pathSection.pathId
                ]?.filter((power) => power.has_power) || [];
                const { anyRootNodes, rootNodes } =
                  buildPowerTreeNodes(selectedPowers);
                const themeColor = pathConfig.themeColor;
                const themeShadow = hexToRgba(themeColor, 0.2);
                const sectionGradient = `linear-gradient(0deg, ${hexToRgba(
                  themeColor,
                  0.12,
                )} 0%, ${hexToRgba(themeColor, 0.03)} 35%, ${hexToRgba(
                  themeColor,
                  0,
                )} 70%)`;
                const anySubtypeLabel = `Any ${pathConfig.displayName} Root`;

                return (
                  <Stack.Item key={pathSection.pathId}>
                    <Section
                      title={pathConfig.displayName}
                      style={{
                        background: sectionGradient,
                        border: `1px solid ${themeColor}`,
                        boxShadow: `0 0 20px ${themeShadow}`,
                      }}
                    >
                      <Stack vertical>
                        {rootNodes.map((powerTreeNode) => (
                          <Stack.Item key={powerTreeNode.power.name}>
                            <NestedPowerTree
                              act={act}
                              collapseFirstLayer={false}
                              depth={0}
                              manuallyRenderedFeatures={
                                manuallyRenderedFeatures
                              }
                              node={powerTreeNode}
                              themeColor={themeColor}
                              themeShadow={themeShadow}
                            />
                          </Stack.Item>
                        ))}
                        {anyRootNodes.length ? (
                          <Stack.Item>
                            <Section
                              title={anySubtypeLabel}
                              style={{
                                background: 'rgba(255, 255, 255, 0.02)',
                                border: `1px solid ${hexToRgba(
                                  themeColor,
                                  0.4,
                                )}`,
                              }}
                            >
                              <Stack vertical>
                                {anyRootNodes.map((powerTreeNode) => (
                                  <Stack.Item key={powerTreeNode.power.name}>
                                    <NestedPowerTree
                                      act={act}
                                      collapseFirstLayer={false}
                                      depth={0}
                                      manuallyRenderedFeatures={
                                        manuallyRenderedFeatures
                                      }
                                      node={powerTreeNode}
                                      themeColor={themeColor}
                                      themeShadow={themeShadow}
                                    />
                                  </Stack.Item>
                                ))}
                              </Stack>
                            </Section>
                          </Stack.Item>
                        ) : null}
                      </Stack>
                    </Section>
                  </Stack.Item>
                );
              })
            ) : (
              <Section
                title="Your Powers"
                style={{
                  border: '1px solid rgba(255, 255, 255, 0.14)',
                }}
              >
                <Box color="label">
                  You have not selected any powers to display.
                </Box>
              </Section>
            )}
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
}
