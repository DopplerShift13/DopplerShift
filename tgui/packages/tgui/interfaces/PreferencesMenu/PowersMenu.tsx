/*
  Front-end page that shows all the possible powers options, and redirects to PowerPathPage.tsx when displaying any of them.
*/

import { Box, Button, Section, Stack } from 'tgui-core/components';

import { resolveAsset } from '../../assets';
import { useBackend } from '../../backend';
import { mergePowerPathData } from './PowerData';
import {
  getPowerPathData,
  getPowerArchetypes,
  getPowerCatalogData,
} from './PowerPathBridge';
import type { Power, PowerPathId, PreferencesMenuData } from './types';

type PowerPageProps = {
  handleOpenSelectedPowers: () => void;
  handleOpenPath: (pathId: PowerPathId) => void;
};

type PathCategoryEntry = {
  assetName?: string;
  color: string;
  isActive: boolean;
  isAvailable: boolean;
  name: string;
  onClick?: () => void;
};

type PathLandingEntry = {
  categories: PathCategoryEntry[];
  name: string;
};

const inactiveIconColor = 'rgba(220, 224, 230, 0.7)';
const activeIconColor = '#f3f6fb';
const inactiveIconBorderColor = 'rgba(255, 255, 255, 0.28)';
const activeIconBorderColor = 'rgba(255, 255, 255, 0.72)';
const inactiveIconInsetBorderColor = 'rgba(255, 255, 255, 0.04)';
const activeIconInsetBorderColor = 'rgba(255, 255, 255, 0.18)';
const defaultIconBackground =
  'linear-gradient(180deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.02))';
const iconButtonSize = '72px';
const iconImageSize = '64px';

function PathIconButton(props: PathCategoryEntry) {
  const { assetName, color, isActive, isAvailable, name, onClick } = props;
  const isClickable = Boolean(isAvailable && onClick);
  const buttonBackground =
    isActive && color
      ? `linear-gradient(180deg, ${color}, ${color})`
      : defaultIconBackground;
  const borderColor = isActive
    ? activeIconBorderColor
    : inactiveIconBorderColor;
  const insetBorderColor = isActive
    ? activeIconInsetBorderColor
    : inactiveIconInsetBorderColor;

  return (
    <Button
      color="transparent"
      disabled={!isClickable}
      onClick={onClick}
      tooltip={isClickable ? undefined : `${name} is not available`}
      tooltipPosition={isClickable ? undefined : 'top'}
      style={{
        alignItems: 'center',
        background: buttonBackground,
        border: `1px solid ${borderColor}`,
        boxShadow: `0 0 0 1px ${insetBorderColor} inset`,
        color: isClickable ? activeIconColor : inactiveIconColor,
        cursor: isClickable ? 'pointer' : 'default',
        display: 'flex',
        height: iconButtonSize,
        justifyContent: 'center',
        minWidth: iconButtonSize,
        opacity: isClickable ? 1 : 0.5,
        padding: '0px',
        width: iconButtonSize,
      }}
    >
      {assetName ? (
        <Box
          as="span"
          style={{
            // These source icons are authored as white silhouettes so the tile color, not the asset itself, carries the path identity.
            backgroundImage: `url("${resolveAsset(assetName)}")`,
            backgroundPosition: 'center',
            backgroundRepeat: 'no-repeat',
            backgroundSize: 'contain',
            display: 'block',
            filter: 'brightness(0) saturate(100%) invert(100%)',
            margin: 'auto',
            opacity: isClickable ? 0.92 : 0.42,
            height: iconImageSize,
            width: iconImageSize,
          }}
        />
      ) : (
        <Box
          as="span"
          style={{
            border: `1px solid ${borderColor}`,
            display: 'block',
            height: '1.6rem',
            opacity: 0.7,
            width: '1.6rem',
          }}
        />
      )}
    </Button>
  );
}

function PathLandingRow(props: PathLandingEntry) {
  const { categories, name } = props;

  return (
    <Section
      fill
      title={name}
      textAlign="center"
      style={{
        background:
          'linear-gradient(180deg, rgba(28, 31, 38, 0.92), rgba(18, 20, 26, 0.95))',
        border: '1px solid rgba(255, 255, 255, 0.14)',
      }}
    >
      <Stack g={1} justify="center">
        {categories.map((categoryEntry) => (
          <Stack.Item key={`${name}-${categoryEntry.name}`}>
            <PathIconButton {...categoryEntry} />
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
}

export const PowersPage = (props: PowerPageProps) => {
  const { data } = useBackend<PreferencesMenuData>();
  const powerCatalogData = getPowerCatalogData();
  const powerArchetypes = getPowerArchetypes(powerCatalogData);
  if (!powerCatalogData) {
    return null;
  }

  const mergedPowerPaths = mergePowerPathData(
    powerCatalogData.power_paths,
    data.power_state_paths,
  );

  const hasAnySelectedPower = (powers: Power[]) =>
    powers.some((powerEntry) => powerEntry.has_power);

  // Landing rows stay data-driven so adding or reordering paths only requires touching shared path config rather than rewriting the layout component.
  const pathRows: PathLandingEntry[] = powerArchetypes.map(
    (archetypeData) => ({
      categories: archetypeData.pathIds.map((pathId) => {
        const pathConfig = getPowerPathData(powerCatalogData, pathId);
        return {
          assetName: pathConfig.iconAssetName,
          color: pathConfig.themeColor,
          isActive: hasAnySelectedPower(mergedPowerPaths[pathId] || []),
          isAvailable: pathConfig.isAvailable,
          name: pathConfig.displayName,
          onClick: pathConfig.isAvailable
            ? () => props.handleOpenPath(pathId)
            : undefined,
        };
      }),
      name: archetypeData.title,
    }),
  );

  return (
    <Stack fill justify="center" pt={2}>
      <Stack.Item grow={0} maxWidth="940px" width="100%">
        <Section
          fill
          style={{
            background:
              'linear-gradient(180deg, rgba(16, 18, 24, 0.96), rgba(10, 12, 18, 0.98))',
            border: '1px solid rgba(255, 255, 255, 0.14)',
          }}
        >
          <Stack vertical g={2}>
            <Stack.Item>
              <Box
                style={{
                  fontSize: '1.55rem',
                  fontWeight: 600,
                  letterSpacing: '0.04em',
                  textAlign: 'center',
                }}
              >
                {data.power_points}/{powerCatalogData.total_power_points}{' '}
                points spent
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Box
                color="label"
                style={{
                  letterSpacing: '0.05em',
                  textAlign: 'center',
                  textTransform: 'uppercase',
                }}
              >
                Select a path to view and assign powers
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Stack justify="center">
                <Stack.Item>
                  <Button
                    color="default"
                    onClick={props.handleOpenSelectedPowers}
                    style={{
                      justifyContent: 'center',
                      minWidth: '180px',
                      textAlign: 'center',
                    }}
                  >
                    Show Your Powers
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack vertical g={1.5}>
                {pathRows.map((pathRow) => (
                  <Stack.Item key={pathRow.name}>
                    <PathLandingRow {...pathRow} />
                  </Stack.Item>
                ))}
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
