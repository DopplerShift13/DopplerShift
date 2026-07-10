/*
  Gets the contents of all the revelant powers for the given path and adjust it's styling and contents based on that.
*/

import { filter } from 'es-toolkit/compat';
import { type ReactNode, useState } from 'react';
import {
  Box,
  Button,
  Collapsible,
  DmIcon,
  Dropdown,
  Floating,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { resolveAsset } from '../../assets';
import { useBackend } from '../../backend';
import { PreferenceList } from './CharacterPreferences/MainPage';
import { mergePowerPathData } from './PowerData';
import { powerPathConfig } from './PowerPathConfig';
import type { Power, PowerPathId, PreferencesMenuData } from './types';
import { useServerPrefs } from './useServerPrefs';

type PowerPathPageProps = {
  handleClosePath: () => void;
  pathId: PowerPathId;
};

export type PowerTreeNode = {
  children: PowerTreeNode[];
  power: Power;
};

export type PowerBuckets = {
  anyRootNodes: PowerTreeNode[];
  rootNodes: PowerTreeNode[];
};

const availablePowerTextColor = 'white';
const unavailablePowerTextColor = 'rgba(255, 255, 255, 0.52)';
const powerTitleIconGutterWidth = '32px';
const powerMagicIndicatorOrder = [
  'unholy',
  'mental',
  'scrying',
  'magical',
] as const;
const powerMagicIndicatorConfig = {
  magical: {
    assetName: 'magic_standard_icon.png',
    tooltip: 'This power is magical and may be susceptible to anti-magic!',
  },
  mental: {
    assetName: 'magic_mental_icon.png',
    tooltip:
      'This power is mental and may be susceptible to mental anti-magics (and tinfoil!)',
  },
  scrying: {
    assetName: 'magic_scrying_icon.png',
    tooltip:
      'This power is a form of scrying and may be susceptible to anti-scrying powers.',
  },
  unholy: {
    assetName: 'magic_unholy_icon.png',
    tooltip: 'This power is unholy and may be susceptible to holy anti-magics!',
  },
} as const;

export function hexToRgba(hexColor: string, alpha: number) {
  const sanitizedHex = hexColor.replace('#', '');
  if (sanitizedHex.length !== 6) {
    return `rgba(255, 255, 255, ${alpha})`;
  }

  const red = Number.parseInt(sanitizedHex.slice(0, 2), 16);
  const green = Number.parseInt(sanitizedHex.slice(2, 4), 16);
  const blue = Number.parseInt(sanitizedHex.slice(4, 6), 16);
  return `rgba(${red}, ${green}, ${blue}, ${alpha})`;
}

function getCorrespondingPreferences(
  customizationOptions: string[],
  relevantPreferences: Record<string, string>,
) {
  return Object.fromEntries(
    filter(Object.entries(relevantPreferences), ([preferenceName]) =>
      customizationOptions.includes(preferenceName),
    ),
  );
}

function isSubtypeRootRequirement(power: Power) {
  return Boolean(
    power.required_allow_subtypes && power.required_powers?.length,
  );
}

function hasSelectedDescendant(node: PowerTreeNode): boolean {
  return node.children.some(
    (childNode) =>
      childNode.power.has_power || hasSelectedDescendant(childNode),
  );
}

function shouldStartExpanded(node: PowerTreeNode, depth: number) {
  if (node.power.has_power || hasSelectedDescendant(node)) {
    return true;
  }

  return depth !== 1 ? false : false;
}

export function buildPowerTreeNodes(powers: Power[]): PowerBuckets {
  const nodeByName = new Map<string, PowerTreeNode>();
  const attachedPowerNames = new Set<string>();
  const anyRootPowerNames = new Set(
    powers.filter(isSubtypeRootRequirement).map((power) => power.name),
  );

  for (const power of powers) {
    nodeByName.set(power.name, {
      children: [],
      power,
    });
  }

  for (const power of powers) {
    if (power.required_allow_subtypes) {
      continue;
    }

    // A power can list multiple requirements, but the shared page only nests it under a concrete parent when one of those requirements exists on-page.
    const parentName = power.required_powers?.find((requiredPowerName) =>
      nodeByName.has(requiredPowerName),
    );

    if (!parentName) {
      continue;
    }

    const parentNode = nodeByName.get(parentName);
    const childNode = nodeByName.get(power.name);

    if (!parentNode || !childNode) {
      continue;
    }

    parentNode.children.push(childNode);
    attachedPowerNames.add(power.name);
  }

  const rootNodes = powers
    .filter(
      (power) =>
        !attachedPowerNames.has(power.name) &&
        !anyRootPowerNames.has(power.name),
    )
    .map((power) => nodeByName.get(power.name))
    .filter(Boolean) as PowerTreeNode[];

  const anyRootNodes = powers
    .filter((power) => anyRootPowerNames.has(power.name))
    .map((power) => nodeByName.get(power.name))
    .filter(Boolean) as PowerTreeNode[];

  return {
    anyRootNodes,
    rootNodes,
  };
}

export function flattenPowerTreeNodes(nodes: PowerTreeNode[]): Power[] {
  const flattenedPowers: Power[] = [];

  function visitNode(node: PowerTreeNode) {
    flattenedPowers.push(node.power);
    for (const childNode of node.children) {
      visitNode(childNode);
    }
  }

  for (const node of nodes) {
    visitNode(node);
  }

  return flattenedPowers;
}

function formatRequirementText(power: Power) {
  if (!power.required_powers?.length) {
    return null;
  }

  const requirementPrefix = power.required_allow_subtypes
    ? 'Requires any subtype of'
    : power.required_allow_any
      ? 'Requires any of'
      : 'Requires';

  return `${requirementPrefix}: ${power.required_powers.join(', ')}`;
}

function getPowerButtonIcon(power: Power) {
  if (Array.isArray(power.powertype)) {
    return (
      power.powertype.find((iconName): iconName is string =>
        Boolean(iconName),
      ) || false
    );
  }

  return power.powertype || false;
}

function getPowerTitleColor(power: Power) {
  return power.state === 'transparent'
    ? unavailablePowerTextColor
    : availablePowerTextColor;
}

function getPowerDescriptionColor(power: Power) {
  return getPowerTitleColor(power);
}

function getPowerButtonWord(power: Power) {
  if (power.state === 'bad') {
    return 'Forget';
  }

  if (power.state === 'good') {
    return 'Learn';
  }

  return 'N/A';
}

function getOrderedPowerMagicFlags(power: Power) {
  const powerMagicFlags = new Set(power.magic_flags || []);
  return powerMagicIndicatorOrder.filter((magicFlag) =>
    powerMagicFlags.has(magicFlag),
  );
}

function InlineCollapsibleTitle(props: {
  children: ReactNode;
  color?: string;
}) {
  const { children, color = availablePowerTextColor } = props;

  return (
    <Box
      style={{
        alignItems: 'center',
        color,
        display: 'inline-flex',
        fontWeight: 700,
        minHeight: '32px',
      }}
    >
      {children}
    </Box>
  );
}

function PowerTitle(props: { power: Power }) {
  const { power } = props;
  const hasActionIcon = Boolean(power.action_icon && power.action_icon_state);

  return (
    <Box
      style={{
        alignItems: 'center',
        display: 'inline-flex',
        gap: '0.6rem',
        minHeight: '32px',
        verticalAlign: 'middle',
        width: '100%',
      }}
    >
      <Box
        style={{
          alignItems: 'center',
          display: 'inline-flex',
          height: '32px',
          justifyContent: 'center',
          width: powerTitleIconGutterWidth,
        }}
      >
        {hasActionIcon ? (
          // Keep title alignment stable even when a power has no action icon to show.
          <DmIcon
            fallback={
              <Box
                style={{
                  height: '32px',
                  width: powerTitleIconGutterWidth,
                }}
              />
            }
            height="32px"
            icon={power.action_icon!}
            icon_state={power.action_icon_state!}
            style={{
              height: '32px',
              width: powerTitleIconGutterWidth,
            }}
            width="32px"
          />
        ) : (
          <Box
            style={{
              height: '32px',
              width: powerTitleIconGutterWidth,
            }}
          />
        )}
      </Box>
      <Box
        style={{
          color: getPowerTitleColor(power),
          display: 'inline-flex',
          fontSize: '1.22rem',
          fontWeight: 700,
          lineHeight: 1.2,
        }}
      >
        {power.name}
      </Box>
    </Box>
  );
}

function PowerControls(props: {
  act: (action: string, payload?: object) => void;
  customizationPreferences: Record<string, string>;
  power: Power;
  themeColor: string;
}) {
  const { act, customizationPreferences, power, themeColor } = props;
  const [customizationExpanded, setCustomizationExpanded] = useState(false);
  const requirementText = formatRequirementText(power);
  const buttonIcon = getPowerButtonIcon(power);
  const customizationOptions = power.customization_options || [];
  const hasCustomization =
    power.customizable && power.has_power && customizationOptions.length > 0;
  const hasExpandableCustomization =
    hasCustomization && Object.entries(customizationPreferences).length > 0;

  return (
    <Stack vertical g={0.75} mt={1.5}>
      <Stack align="center">
        <Stack.Item grow>
          <Box
            style={{
              color: getPowerDescriptionColor(power),
            }}
          >
            <b>{`Cost: ${power.cost}`}</b>
          </Box>
          {requirementText ? (
            <Box
              fontSize="0.9em"
              mt={0.5}
              style={{
                color: getPowerDescriptionColor(power),
              }}
            >
              {requirementText}
            </Box>
          ) : null}
        </Stack.Item>
        {getOrderedPowerMagicFlags(power).map((magicFlag) => {
          const indicatorConfig = powerMagicIndicatorConfig[magicFlag];
          return (
            <Stack.Item key={`${power.name}-${magicFlag}`}>
              <Tooltip content={indicatorConfig.tooltip} position="top">
                <Box
                  style={{
                    alignItems: 'center',
                    backgroundImage: `url("${resolveAsset(indicatorConfig.assetName)}")`,
                    backgroundPosition: 'center',
                    backgroundRepeat: 'no-repeat',
                    backgroundSize: 'contain',
                    display: 'inline-flex',
                    height: '16px',
                    justifyContent: 'center',
                    width: '16px',
                  }}
                />
              </Tooltip>
            </Stack.Item>
          );
        })}
        {hasCustomization ? (
          <Stack.Item>
            <Floating
              // Customization values already live in preferences; this just exposes the relevant subset for the learned power.
              content={
                hasExpandableCustomization ? (
                  <Box
                    onClick={(event) => {
                      event.stopPropagation();
                    }}
                    style={{
                      boxShadow: '0px 4px 8px 3px rgba(0, 0, 0, 0.7)',
                    }}
                  >
                    <Stack
                      backgroundColor="black"
                      maxWidth="300px"
                      px="5px"
                      py="3px"
                    >
                      <Stack.Item>
                        <PreferenceList
                          maxHeight="100px"
                          preferences={customizationPreferences}
                          randomizations={{}}
                        />
                      </Stack.Item>
                    </Stack>
                  </Box>
                ) : null
              }
              onOpenChange={setCustomizationExpanded}
              placement="bottom-end"
              stopChildPropagation
            >
              <div style={{ display: 'flow-root' }}>
                <Button
                  icon="cog"
                  selected={customizationExpanded}
                  tooltip="Customize"
                />
              </div>
            </Floating>
          </Stack.Item>
        ) : null}
        <Stack.Item>
          <Button
            color={power.state}
            icon={buttonIcon}
            onClick={() => {
              if (power.state === 'bad') {
                act('remove_power', { power_name: power.name });
                return;
              }

              act('give_power', { power_name: power.name });
            }}
            style={{
              backgroundColor:
                power.state === 'bad'
                  ? undefined
                  : power.has_power
                    ? themeColor
                    : undefined,
              color:
                power.state === 'bad'
                  ? undefined
                  : power.has_power
                    ? 'black'
                    : undefined,
            }}
            tooltip={requirementText}
            tooltipPosition="top"
          >
            {getPowerButtonWord(power)}
          </Button>
        </Stack.Item>
      </Stack>
      {power.augment?.is_arm && power.has_power ? (
        <Stack.Item>
          <Dropdown
            disabled={
              power.augment?.left_blocked && power.augment?.right_blocked
            }
            options={[
              ...(power.augment?.left_blocked ? [] : ['Left']),
              ...(power.augment?.right_blocked ? [] : ['Right']),
              ...(!power.augment?.left_blocked && !power.augment?.right_blocked
                ? ['Both']
                : []),
            ]}
            placeholder="Arm"
            selected={power.augment?.assignment || undefined}
            width="140px"
            onSelected={(value) =>
              act('set_augment_arm', {
                power_name: power.name,
                side: value,
              })
            }
          />
        </Stack.Item>
      ) : power.augment?.location ? (
        <Stack.Item>
          <Box color="label" fontSize="0.9em">
            {`Location: ${power.augment.location}`}
          </Box>
        </Stack.Item>
      ) : null}
    </Stack>
  );
}

function PowerSummaryCard(props: {
  act: (action: string, payload?: object) => void;
  manuallyRenderedFeatures: Record<string, string>;
  power: Power;
  themeColor: string;
  themeShadow: string;
}) {
  const { act, manuallyRenderedFeatures, power, themeColor, themeShadow } =
    props;
  const customizationOptions = power.customization_options || [];
  const customizationPreferences =
    power.customizable && power.has_power && customizationOptions.length > 0
      ? getCorrespondingPreferences(
          customizationOptions,
          manuallyRenderedFeatures,
        )
      : {};

  return (
    <Section
      style={{
        background: power.has_power
          ? hexToRgba(themeColor, 0.08)
          : 'rgba(255, 255, 255, 0.02)',
        border: power.has_power
          ? `1px solid ${themeColor}`
          : '1px solid rgba(255, 255, 255, 0.12)',
        boxShadow: power.has_power ? `0 0 16px ${themeShadow}` : 'none',
      }}
    >
      <Box mb={1}>
        <PowerTitle power={power} />
      </Box>
      <Box
        style={{
          color: getPowerDescriptionColor(power),
          lineHeight: 1.45,
          whiteSpace: 'pre-line',
        }}
      >
        {power.description}
      </Box>
      <PowerControls
        act={act}
        customizationPreferences={customizationPreferences}
        power={power}
        themeColor={themeColor}
      />
    </Section>
  );
}

export function NestedPowerTree(props: {
  act: (action: string, payload?: object) => void;
  collapseFirstLayer?: boolean;
  depth: number;
  manuallyRenderedFeatures: Record<string, string>;
  node: PowerTreeNode;
  themeColor: string;
  themeShadow: string;
}) {
  const {
    act,
    collapseFirstLayer = true,
    depth,
    manuallyRenderedFeatures,
    node,
    themeColor,
    themeShadow,
  } = props;

  const nestedContent = (
    <Box
      ml={depth > 0 ? '1.25rem' : undefined}
      mt={depth > 0 ? 1 : undefined}
      style={{
        borderLeft:
          depth > 0 ? '2px solid rgba(255, 255, 255, 0.08)' : undefined,
        paddingLeft: depth > 0 ? '0.9rem' : undefined,
      }}
    >
      <PowerSummaryCard
        act={act}
        manuallyRenderedFeatures={manuallyRenderedFeatures}
        power={node.power}
        themeColor={themeColor}
        themeShadow={themeShadow}
      />
      {node.children.length ? (
        <Stack vertical mt={1}>
          {node.children.map((childNode) => (
            <Stack.Item key={`${node.power.name}-${childNode.power.name}`}>
              <NestedPowerTree
                act={act}
                collapseFirstLayer={collapseFirstLayer}
                depth={depth + 1}
                manuallyRenderedFeatures={manuallyRenderedFeatures}
                node={childNode}
                themeColor={themeColor}
                themeShadow={themeShadow}
              />
            </Stack.Item>
          ))}
        </Stack>
      ) : null}
    </Box>
  );

  if (!collapseFirstLayer || depth !== 1) {
    return nestedContent;
  }

  return (
    <Collapsible
      // Only the first child layer collapses. Deeper nesting stays expanded to avoid turning the tree into nested accordion soup.
      color="transparent"
      open={shouldStartExpanded(node, depth)}
      textColor={getPowerTitleColor(node.power)}
      title={
        <InlineCollapsibleTitle color={getPowerTitleColor(node.power)}>
          <PowerTitle power={node.power} />
        </InlineCollapsibleTitle>
      }
    >
      {nestedContent}
    </Collapsible>
  );
}

export function PowerPathPage(props: PowerPathPageProps) {
  const { act, data } = useBackend<PreferencesMenuData>();
  const serverData = useServerPrefs();
  const { handleClosePath, pathId } = props;
  if (!serverData) {
    return null;
  }

  const mergedPowerPaths = mergePowerPathData(
    serverData.powers.power_paths,
    data.power_state_paths,
  );
  const pathConfig = powerPathConfig[pathId];
  const pathPowers = mergedPowerPaths[pathId];
  const { anyRootNodes, rootNodes } = buildPowerTreeNodes(pathPowers);
  const selectedPowers = flattenPowerTreeNodes([
    ...rootNodes,
    ...anyRootNodes,
  ]).filter((power) => power.has_power);
  const themeColor = pathConfig.themeColor;
  const themeShadow = hexToRgba(themeColor, 0.2);
  const overviewGlow = hexToRgba(themeColor, 0.06);
  const mechanicsGlow = hexToRgba(themeColor, 0.08);
  const accentBorder = hexToRgba(themeColor, 0.5);
  const pageGradient = `linear-gradient(0deg, ${hexToRgba(
    themeColor,
    0.14,
  )} 0%, ${hexToRgba(themeColor, 0.05)} 28%, ${hexToRgba(themeColor, 0)} 64%)`;
  const pageBackground = 'rgba(20, 22, 28, 0.98)';
  const anySubtypeLabel = `Any ${pathConfig.displayName} Root`;
  const manuallyRenderedFeatures =
    data.character_preferences.manually_rendered_features;

  return (
    <Box
      style={{
        // The gradient is fixed so the path color reads as ambient theming rather than scrolling content.
        backgroundColor: pageBackground,
        backgroundImage: pageGradient,
        backgroundAttachment: 'fixed',
        backgroundPosition: 'bottom center',
        backgroundRepeat: 'no-repeat',
        minHeight: '100%',
        padding: '0.5rem',
      }}
    >
      <Stack align="stretch" fill g={2}>
        <Stack.Item minWidth="260px" shrink={0}>
          <Stack vertical>
            <Stack.Item>
              <Section
                title={pathConfig.displayName}
                style={{
                  border: `1px solid ${themeColor}`,
                  boxShadow: `0 0 20px ${themeShadow}`,
                }}
              >
                <Box
                  style={{
                    fontSize: '1.4rem',
                    fontWeight: 600,
                    textAlign: 'center',
                  }}
                >
                  {data.power_points}/{serverData.powers.total_power_points}{' '}
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
                  {`${selectedPowers.length} selected powers`}
                </Box>
                <Button
                  fluid
                  icon="arrow-left"
                  mt={1.5}
                  onClick={handleClosePath}
                  style={{
                    backgroundColor: themeColor,
                    color: 'black',
                  }}
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
                {selectedPowers.length ? (
                  <Stack vertical>
                    {selectedPowers.map((power) => (
                      <Stack.Item key={power.name}>
                        <Section
                          style={{
                            border: '1px solid rgba(255, 255, 255, 0.12)',
                          }}
                        >
                          <Stack align="center">
                            <Stack.Item grow>
                              <Box
                                style={{
                                  color: 'white',
                                }}
                              >
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
                        </Section>
                      </Stack.Item>
                    ))}
                  </Stack>
                ) : (
                  <Box color="label">{`No ${pathConfig.displayName} powers selected.`}</Box>
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow>
          <Stack vertical fill>
            <Stack.Item>
              <Section
                title="Path Overview"
                style={{
                  background: overviewGlow,
                  border: `1px solid ${themeColor}`,
                  boxShadow: `0 0 18px ${themeShadow}`,
                }}
              >
                <Box
                  style={{
                    color: 'rgba(255, 255, 255, 0.86)',
                    lineHeight: 1.45,
                  }}
                >
                  {pathConfig.overviewText}
                </Box>
                <Box
                  mt={1.25}
                  style={{
                    background: mechanicsGlow,
                    border: `1px solid ${accentBorder}`,
                    boxShadow: `0 0 14px ${themeShadow}`,
                    padding: '0.35rem 0.5rem 0.5rem',
                  }}
                >
                  <Collapsible
                    color="transparent"
                    title={
                      <InlineCollapsibleTitle>Mechanics</InlineCollapsibleTitle>
                    }
                    textColor="white"
                  >
                    <Box
                      mt={1}
                      style={{
                        color: 'rgba(255, 255, 255, 0.88)',
                        lineHeight: 1.45,
                        whiteSpace: 'pre-line',
                      }}
                    >
                      {pathConfig.mechanicsText}
                    </Box>
                  </Collapsible>
                </Box>
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section
                fill
                title="Available Powers"
                style={{
                  border: `1px solid ${themeColor}`,
                  boxShadow: `0 0 20px ${themeShadow}`,
                }}
              >
                <Stack vertical>
                  {rootNodes.map((powerTreeNode) => (
                    <Stack.Item key={powerTreeNode.power.name}>
                      <PowerSummaryCard
                        act={act}
                        manuallyRenderedFeatures={manuallyRenderedFeatures}
                        power={powerTreeNode.power}
                        themeColor={themeColor}
                        themeShadow={themeShadow}
                      />
                      {powerTreeNode.children.length ? (
                        <Stack vertical mt={1}>
                          {powerTreeNode.children.map((childNode) => (
                            <Stack.Item
                              key={`${powerTreeNode.power.name}-${childNode.power.name}`}
                            >
                              <NestedPowerTree
                                act={act}
                                depth={1}
                                manuallyRenderedFeatures={
                                  manuallyRenderedFeatures
                                }
                                node={childNode}
                                themeColor={themeColor}
                                themeShadow={themeShadow}
                              />
                            </Stack.Item>
                          ))}
                        </Stack>
                      ) : null}
                    </Stack.Item>
                  ))}
                  {/* The "any root power" collapsible starts off expanded*/}
                  {anyRootNodes.length ? (
                    <Stack.Item>
                      <Collapsible
                        color="transparent"
                        open
                        textColor="white"
                        title={
                          <InlineCollapsibleTitle>
                            {anySubtypeLabel}
                          </InlineCollapsibleTitle>
                        }
                      >
                        <Stack vertical mt={1}>
                          {anyRootNodes.map((powerTreeNode) => (
                            <Stack.Item key={powerTreeNode.power.name}>
                              <NestedPowerTree
                                act={act}
                                depth={1}
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
                      </Collapsible>
                    </Stack.Item>
                  ) : null}
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
}
