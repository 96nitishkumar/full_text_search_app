class AddTsVectorToUpdateTriggerToArticles < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE FUNCTION articles_tsvector_update() RETURNS trigger AS $$
      BEGIN
        NEW.tsv :=
          setweight(to_tsvector('pg_catalog.english', coalesce(new.name, '')), 'A') ||
          setweight(to_tsvector('pg_catalog.english', coalesce(new.description, '')), 'B');
        RETURN NEW;
      END
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON articles FOR EACH ROW EXECUTE FUNCTION articles_tsvector_update();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS tsvectorupdate ON articles;
      DROP FUNCTION articles_tsvector_update();
    SQL
  end
end
