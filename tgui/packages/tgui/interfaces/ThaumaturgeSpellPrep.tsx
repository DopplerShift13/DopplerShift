import { Box, Button, DmIcon, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type SpellEntry = {
  key: string;
  name: string;
  charges: number;
  max_charges: number;
  prep_cost: number;
  icon?: string;
  icon_state?: string;
};

type Data = {
  tguitheme?: string;
  mana_remaining: number;
  mana_total: number;
  mana_max: number;
  first_time_preperation: boolean;
  spell_count: number;
  spells: SpellEntry[];
};

export const ThaumaturgeSpellPrep = (_props) => {
  const { data, act } = useBackend<Data>();
  const spells = data.spells || [];

  return (
    <Window
      theme={data.tguitheme}
      title="Spell Preparation"
      width={640}
      height={520}
    >
      <Window.Content scrollable>
        <Section title="Mana">
          <Box>
            Mana remaining: <b>{data.mana_remaining}</b> /{' '}
            <b>{data.mana_total}</b>
          </Box>
        </Section>

        <Section title={`Spells (${data.spell_count})`}>
          <Stack wrap>
            {spells.map((spell) => (
              <Stack.Item key={spell.key} basis="150px" grow={0} shrink={0}>
                <Section fitted>
                  <Stack vertical align="center">
                    <Stack.Item>
                      <Stack align="center">
                        <Stack.Item>
                          <Button
                            icon="plus"
                            color="good"
                            disabled={spell.charges >= spell.max_charges}
                            onClick={() => act('inc', { ref: spell.key })}
                          />
                        </Stack.Item>

                        <Stack.Item>
                          <Box
                            width="24px"
                            textAlign="center"
                            style={{ fontWeight: 'bold' }}
                          >
                            {spell.charges}
                          </Box>
                        </Stack.Item>

                        <Stack.Item>
                          <Button
                            icon="minus"
                            color="bad"
                            disabled={spell.charges <= 0}
                            onClick={() => act('dec', { ref: spell.key })}
                          />
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>

                    <Stack.Item>
                      <DmIcon
                        icon={
                          spell.icon ?? 'icons/mob/actions/actions_spells.dmi'
                        }
                        icon_state={spell.icon_state ?? 'default'}
                        width="64px"
                        height="64px"
                      />
                    </Stack.Item>

                    <Stack.Item>
                      <Box textAlign="center">{spell.name}</Box>
                      <Box textAlign="center">Cost: {spell.prep_cost}</Box>
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
            ))}
          </Stack>
        </Section>

        <Section>
          <Stack vertical>
            <Stack.Item>
              {data.first_time_preperation ? (
                <Box color="bad">
                  Preparing spells for the first time applies the charges
                  instantly!
                </Box>
              ) : (
                <Box>
                  Your prepared charges will be applied the next time you sleep.
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              <Button color="bad" width="100%" onClick={() => act('apply')}>
                Apply Prepared Spells
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
