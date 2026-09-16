ALTER TABLE public.operations
  ADD COLUMN IF NOT EXISTS libelle text,
  ADD COLUMN IF NOT EXISTS beneficiaire text,
  ADD COLUMN IF NOT EXISTS statut text NOT NULL DEFAULT 'En attente',
  ADD COLUMN IF NOT EXISTS imputation_id uuid REFERENCES public.imputations(id) ON DELETE SET NULL;

COMMENT ON COLUMN public.operations.imputation_id IS 'Compte du plan comptable (imputations) imputé à l opération de caisse';

UPDATE public.operations
   SET libelle = COALESCE(NULLIF(description, ''), NULLIF(reference, ''), 'Opération de caisse')
 WHERE libelle IS NULL;

CREATE INDEX IF NOT EXISTS operations_imputation_id_idx ON public.operations (imputation_id);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.operations TO authenticated;
GRANT ALL ON public.operations TO service_role;